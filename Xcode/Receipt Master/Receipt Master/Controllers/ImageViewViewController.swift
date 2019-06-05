//
//  ImageViewViewController.swift
//  Receipt Master
//
//  Created by Jeremy Chan on 5/6/19.
//  Copyright © 2019 Jeremy Chan. All rights reserved.
//

import Foundation
import UIKit

/**
 * VC for displaying selected Receipt
 */
class ImageViewViewController: UIViewController {
    
    //Fields to display.
    var filePath:String = ""
    var name:String = ""
    var desc:String = ""
    var creationDate:String = ""
    
    // UI Labels
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get image file path so it can be displayed.
        let file = URL.init(string: filePath)
        let img = UIImage.init(contentsOfFile: file!.path)!
        
        //Set the UI Components with values to display tothe user.
        self.imageView.image = img
        self.nameLbl.text = self.name
        self.descLbl.text = self.desc
        self.dateLabel.text = self.creationDate

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    @IBAction func dismissV(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

