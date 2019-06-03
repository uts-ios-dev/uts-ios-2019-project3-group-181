//
//  Receipt.swift
//  Receipt Master
//
//  Created by Luke Chalkley on 25/5/19.
//  Copyright © 2019 Jeremy Chan. All rights reserved.
//

import Foundation
import RealmSwift

class Receipt : Object{
    @objc dynamic var creationDate = Date()
    
    //  One-to-many for relationships for Receipt to Category and Store.
    //  @objc dynamic var category: Category!
    //  @objc dynamic var store: Store!
    
    //  Are these the correct field names we want?
    @objc dynamic var  entryName:String = ""
    @objc dynamic var  imageLocation = ""
    @objc dynamic var  entryDescription:String = ""
    @objc dynamic var  longitude:Double = 0.0
    @objc dynamic var  latitude:Double = 0.0
}
