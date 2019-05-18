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

class NewReceiptViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var cameraView: UIView!
    //Contain image from camera in this view later
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    //Location and camera.
    let locationManager = CLLocationManager()
    var imagePicker: UIImagePickerController!

    
    //Fields to store entry info.
    var currentLocation:String?
    var entryName:String?
    var entryDescription:String?
    var longitude:Double?
    var latitude:Double?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        entryName = nameTextField.text!
        entryDescription = descriptionTextField.text!
        
        self.dismiss(animated: true, completion: nil)
        
        print(entryName)
        print(entryDescription)
        print(longitude)
        print(latitude)
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
