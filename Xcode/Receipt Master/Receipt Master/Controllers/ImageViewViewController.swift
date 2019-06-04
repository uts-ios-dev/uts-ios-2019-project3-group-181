//
//  ImageViewViewController.swift
//  Receipt Master
//
//  Created by Jeremy Chan on 5/6/19.
//  Copyright © 2019 Jeremy Chan. All rights reserved.
//

import Foundation
import UIKit
class ImageViewViewController: UIViewController {
    var filePath:String = ""
    var name:String = ""
    var desc:String = ""
    
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let file = URL.init(string: filePath)
        let img = UIImage.init(contentsOfFile: file!.path)!
        self.imageView.image = img
        self.nameLbl.text = self.name
        self.descLbl.text = self.desc
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    @IBAction func dismissV(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

