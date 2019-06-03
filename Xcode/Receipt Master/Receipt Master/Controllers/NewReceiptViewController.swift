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
    
    var newReceipt : Receipt!
    var realm : Realm!
    
    //Location and camera.
    let locationManager = CLLocationManager()
    var imagePicker: UIImagePickerController!
    let geocoder = CLGeocoder()

    
    
    //Fields to store entry info.
    var longitude:Double?
    var latitude:Double?
    
    var streetNum: String?
    var streetName: String?
    var locality :String?
    var administrativeArea :String?
    var country :String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        //Save name, description, and location.
        //entryName = nameTextField.text!
        //entryDescription = descriptionTextField.text!
        newReceipt = Receipt()
        newReceipt.entryName = nameTextField.text!
        newReceipt.entryDescription = descriptionTextField.text!
        
        if let lat = latitude{
            newReceipt.latitude = lat
        }
        
        if let long = longitude{
            newReceipt.longitude = long
        }
        
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
    
    @IBAction func chooseFromGalleryButtonPressed(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

