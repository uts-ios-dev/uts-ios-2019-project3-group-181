//
//  NewReceiptViewController.swift
//  Receipt Master
//
//  Created by Jeremy Chan on 17/5/19.
//  Copyright © 2019 Jeremy Chan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

/**
 * VC for new receipt entry submission.
 */
class NewReceiptViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //Fields for UI components.
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    //DB model and framework.
    var newReceipt : Receipt!
    var realm : Realm!
    
    //Location and image picker.
    let locationManager = CLLocationManager()
    var imagePicker: UIImagePickerController!
    let geocoder = CLGeocoder()

    
    
    //Fields to store entry info.
    var longitude:Double?
    var latitude:Double?
    var photoFileName: String?
    
    //Fields for location.
    var streetNum: String?
    var streetName: String?
    var locality :String?
    var administrativeArea :String?
    var country :String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //  This just prints the location of the file to debug terminal so we can find the database file.
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    
    // =============== Location ==================
    
    /**
     * Triggered when switch is toggled.
     */
    @IBAction func useLocation(_ sender: UISwitch) {
        

        
        //Request location authorization when the app used for the first time.
        locationManager.requestWhenInUseAuthorization()
        
        //Start receiving location info if location is enabled.
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    /**
     * Used by locationManager to get the location. Also saves location names to fields.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        //Print location to console and save to fields.
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        longitude = locValue.longitude
        latitude = locValue.latitude
        
        let location = CLLocation(latitude: latitude!, longitude: longitude!)
        
        
        // Get the reverseGeolocation details.
        // Some code adapted from: https://stackoverflow.com/questions/41358423/swift-generate-an-address-format-from-reverse-geocoding
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("Error in reverseGeocode")
            }
            
            //Get location names, and store them in fields/label to be sent to database.
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                self.locality = placemark.locality!
                self.administrativeArea = placemark.administrativeArea!
                self.country = placemark.country!
                self.streetName = placemark.thoroughfare!
                self.streetNum = placemark.subThoroughfare!
                print(self.locality! + self.administrativeArea! + self.country!)
                self.locationLabel.text =  self.streetNum! +  " "  + self.streetName! +  ", "  +  self.locality! + ", "  + self.country!
            }
        })
        
    }

    

    
    // =============== Image Picker ==================
    
    /*
     * Initiate camera.
     */
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    /*
     * Handle camera and camera url.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        //Show this photo in ImageView
        photoView.image = info[.originalImage] as? UIImage
        
        //Set fileUrl for Receipt entry.
        if let fileUrl = info[.imageURL] as? URL{
            photoFileName = fileUrl.absoluteString
        }
    }
    
    /*
     * Handle done button by checking input and sending info to database.
     */
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if (!nameTextField.hasText || !descriptionTextField.hasText){
            let alert = UIAlertController(title: "Incomplete Fields", message: "Name and Description of Receipt is required.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
        }
        else{
        //Save name, description, and location.
        newReceipt = Receipt()
        newReceipt.entryName = nameTextField.text!
        newReceipt.entryDescription = descriptionTextField.text!
        
        //  The following series of optional lets are simply just in case
        //  the user doesn't set location or choose image.
        
            
        // Checks if location set.
        if let lat = latitude{
            newReceipt.latitude = lat
        }
        
        //  Checks if location set.
        if let long = longitude{
            newReceipt.longitude = long
        }
        
        if let locationName = self.locationLabel.text{
            newReceipt.locationName = locationName
        }
        
        if let photoFileName = photoFileName{
            newReceipt.imageLocation = photoFileName
        }
        
        //  Currently no errors have been detected - however will be printed here.
        //  Documentation says errors are rare unless resources constrained - and these will happen when
        //  you first create/open the realm file
        do {
            realm = try Realm()
            
            try realm.write() {
                realm.add(newReceipt)
            }
        }
        catch let error as NSError {
            print(error)
        }
        
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    /*
     * Allows photos to be selected from the device's gallery.
     */
    @IBAction func chooseFromGalleryButtonPressed(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
        if (nameTextField.hasText && descriptionTextField.hasText){
            doneButton.isEnabled = true
        }
    }
  
    /*
     * Check for valid input for receipt entries.
     */
    @IBAction func checkValidEntry(_ sender: Any) {
        if (nameTextField.hasText && descriptionTextField.hasText){
            doneButton.isEnabled = true
        }
    }
}

