//
//  Receipt.swift
//  Receipt Master
//
//  Created by Luke Chalkley on 25/5/19.
//  Copyright © 2019 Jeremy Chan. All rights reserved.
//

import Foundation
import RealmSwift

//  Model used to store our Receipt. This conforms to Object
//  so Realm can insert into the database.

//  This allows a code-first rather than database-design first approach.
//  If a different database approach is required, then the model can simply
//  ignore the Realm import and use a proper Database controller.
class Receipt : Object{
    @objc dynamic var creationDate = Date()
    
    //  One-to-many for relationships for Receipt to Category and Store.
    //  @objc dynamic var category: Category!
    //  @objc dynamic var store: Store!
    
    //  Default values are required for Realm.
    @objc dynamic var  entryName:String = ""
    @objc dynamic var  imageLocation = ""   //  This is the physical name of the image file on the device. We store filepath not contents.
    @objc dynamic var  entryDescription:String = ""
    @objc dynamic var  longitude:Double = 0.0
    @objc dynamic var  latitude:Double = 0.0
    @objc dynamic var  locationName:String = ""
}
