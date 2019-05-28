//
//  SavedReceiptsViewController.swift
//  Receipt Master
//
//  Created by Jeremy Chan on 17/5/19.
//  Copyright © 2019 Jeremy Chan. All rights reserved.
//

import UIKit
import RealmSwift

class SavedReceiptsViewController: UIViewController, UITableViewDataSource {
    
    var receipts : Results<Receipt>!
    
    @IBOutlet weak var tableView: UITableView!
    
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
        #warning("Do we want to use sections?")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            receipts = try Realm().objects(Receipt.self)
        }
        catch (let error as NSError){
            print(error)
        }
        
        //  We need to tell the tableview where its source is.
        tableView.dataSource = self

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
