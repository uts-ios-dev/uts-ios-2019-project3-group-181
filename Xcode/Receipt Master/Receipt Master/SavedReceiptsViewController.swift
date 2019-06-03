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


class SavedReceiptsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var receipts : Results<Receipt>!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            receipts = try Realm().objects(Receipt.self)
        }
        catch (let error as NSError){
            print(error)
        }
        
        //  We need to tell the tableview where its source is.
        //        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        
        populateMap()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipts.count
        //P.s. Read up on how to use UITableView. Cheers.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
        
        let text = receipts[indexPath.row]
        
        cell.textLabel?.text = text.entryName
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        Stack Overflow- UIImage Alert View
        let alert = UIAlertController(title: receipts[indexPath.row].entryName, message: receipts[indexPath.row].entryDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        let imgTitle = UIImage(named:"imgTitle.png")
//        let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
//        imgViewTitle.image = imgTitle
//        alert.view.addSubview(imgViewTitle)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//
//        #warning("Do we want to use sections?")
//        Nah
//    }
    
    //==============Map stuff========================
    
    
    /**
    * Populate the mapView with markers.
    */
    func populateMap() {
        //Remove existing markers.
        mapView.removeAnnotations(mapView.annotations)
        
        // Create annotations for each coordinate/entry.
        for receipt in receipts {
            let coord = CLLocationCoordinate2D(
                latitude: receipt.latitude,
                longitude: receipt.longitude);
            
            let receiptAnnotation = MKPointAnnotation()
            receiptAnnotation.title = receipt.entryName
            receiptAnnotation.subtitle = receipt.entryDescription
            receiptAnnotation.coordinate = coord
            
            mapView.addAnnotation(receiptAnnotation)
        }
    }
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
