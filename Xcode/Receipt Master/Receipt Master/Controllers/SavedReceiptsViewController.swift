//
//  SavedReceiptsViewController.swift
//  Receipt Master
//
//  Created by Jeremy Chan on 17/5/19.
//  Copyright © 2019 Jeremy Chan. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit

/*
 * VC to view saved Receipts.
 */
class SavedReceiptsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var receipts : Results<Receipt>!
    //Views
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    //Fields to send over to ImageViewViewController
    var imageLocation = ""
    var name = ""
    var desc = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get receipts from DB. 
        do{
            receipts = try Realm().objects(Receipt.self)
        }
        catch (let error as NSError){
            print(error)
        }
        
        //Trigger population of map.
        populateMap()
        
    }
    
    /*
     * Set number of rows in table.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if receipts != nil{
        return receipts.count
        }
        
        return 0
    }
    
    /*
     * Set the cells of the table.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!    //  Reusabe cell from UI.
        
        //Get the receipts.
        let receipt = receipts[indexPath.row]
        
        //Set the display to name and description, or whatever we wish to display.
        cell.textLabel?.text = receipt.entryName + " - " + receipt.entryDescription
        
        return cell
        
    }
    
    /*
     *  Handle selection of receipt entry.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Get the values
        self.imageLocation = receipts[indexPath.row].imageLocation
        self.name = receipts[indexPath.row].entryName
        self.desc = receipts[indexPath.row].entryDescription
        
        //Save values to pass on
        self.performSegue(withIdentifier: "toImg", sender: self)
        let coordinate = CLLocationCoordinate2D.init(latitude: receipts[indexPath.row].latitude, longitude: receipts[indexPath.row].longitude)
        mapView.setCenter(coordinate, animated: true)
    }
    
    
    
    //Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toImg") {
            let vc = segue.destination as! ImageViewViewController
            vc.filePath = self.imageLocation
            vc.name = self.name
            vc.desc = self.desc
        }
    }
    
    
    //==============MapKit========================
    
    /**
    * Populate the mapView with markers.
    */
    func populateMap() {
        //Remove existing markers.
        mapView.removeAnnotations(mapView.annotations)
        
        // Create annotations for each coordinate/entry.
        if let receipts = receipts{
        for receipt in receipts {
            let coord = CLLocationCoordinate2D(
                latitude: receipt.latitude,
                longitude: receipt.longitude);
            
            //Initialize marker/annotation with values (name, description, coordinates)
            let receiptAnnotation = MKPointAnnotation()
            receiptAnnotation.title = receipt.entryName
            receiptAnnotation.subtitle = receipt.entryDescription
            receiptAnnotation.coordinate = coord
            
            //Add the annotation to the mapView (marker).
            mapView.addAnnotation(receiptAnnotation)
            }
        }
    }
    
    /**
     * Re-use map markers/pins with using identifiers.
     *  Function code adapted from tutorial on: https://www.hackingwithswift.com/example-code/location/how-to-add-annotations-to-mkmapview-using-mkpointannotation-and-mkpinannotationview
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }

 
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
