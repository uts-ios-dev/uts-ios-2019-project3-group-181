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

class NewReceiptViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    var newReceipt : Receipt!
    var realm : Realm!
    
    //Location and camera.
    let locationManager = CLLocationManager()
    var imagePicker: UIImagePickerController!
    let geocoder = CLGeocoder()

    
    
    //Fields to store entry info.
    var longitude:Double?
    var latitude:Double?
    
    var photoFileName: String?
    
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
        
        //To request location authorization always, use this line of code:
        //  locationManager.requestAlwaysAuthorization()
        
        //Otherwise, to request location authorization when the app is in use:
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    /**
     * Used by locationManager to get the location.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        //Print location to console and save to fields.
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        longitude = locValue.longitude
        latitude = locValue.latitude
        
        let location = CLLocation(latitude: latitude!, longitude: longitude!)
        
        
        // Some code adapted from https://stackoverflow.com/questions/41358423/swift-generate-an-address-format-from-reverse-geocoding
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("Error in reverseGeocode")
            }
            
            
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

    

    
    // =============== Camera ==================
    
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        photoView.image = info[.originalImage] as? UIImage
        
        if let fileUrl = info[.imageURL] as? URL{
            photoFileName = fileUrl.absoluteString
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if (!nameTextField.hasText || !descriptionTextField.hasText){
            let alert = UIAlertController(title: "Incomplete Fields", message: "Name and Description of Receipt is required.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
        }
        else{
        //Save name, description, and location.
        //entryName = nameTextField.text!
        //entryDescription = descriptionTextField.text!
        newReceipt = Receipt()
        newReceipt.entryName = nameTextField.text!
        newReceipt.entryDescription = descriptionTextField.text!
        
        //  The following series of optional lets are simply just in case
        //  the user doesn't set location or choose image.
        
        //  Why are we allowing them to add an entry without an accommpanied image?
            
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
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func checkValidEntry(_ sender: Any) {
        if (nameTextField.hasText && descriptionTextField.hasText){
            doneButton.isEnabled = true
        }
    }
}

