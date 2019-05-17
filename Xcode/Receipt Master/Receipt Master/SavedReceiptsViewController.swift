//
//  SavedReceiptsViewController.swift
//  Receipt Master
//
//  Created by Jeremy Chan on 17/5/19.
//  Copyright © 2019 Jeremy Chan. All rights reserved.
//

import UIKit

class SavedReceiptsViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        #warning("Fill this up with proper data")
        return 0
        //P.s. Read up on how to use UITableView. Cheers.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        #warning("Fill this up with proper data")
        return UITableViewCell.init()
        //P.s. Read up on how to use UITableView. Cheers.
    }
    

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
