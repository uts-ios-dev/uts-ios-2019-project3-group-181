//
//  NewReceiptViewController.swift
//  Receipt Master
//
//  Created by Jeremy Chan on 17/5/19.
//  Copyright © 2019 Jeremy Chan. All rights reserved.
//

import UIKit

class NewReceiptViewController: UIViewController {
    @IBOutlet weak var cameraView: UIView!
    //Contain image from camera in this view later
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
