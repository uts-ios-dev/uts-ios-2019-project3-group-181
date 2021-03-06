//
//  ViewController.swift
//  Receipt Master
//
//  Created by Jeremy Chan on 17/5/19.
//  Copyright © 2019 Jeremy Chan. All rights reserved.
//

import UIKit
import RealmSwift


/*
 * Entry VC.
 */
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    /**
     * The following code snippets are just for debug purpose
     * and allow us to clear the Realm database file from the device.
     */
    @IBAction func resetDatabaseButtonPressed(_ sender: Any) {
        print("Cleaning database")
        do {
            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
            
            let alert = UIAlertController(title: "Cache Deleted", message: "Realm Database Deleted", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
        }
        catch let error as NSError {
            print(error)
        }
    }
}

