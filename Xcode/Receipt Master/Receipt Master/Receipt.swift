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
    @objc dynamic var category: Category!
    @objc dynamic var store: Store!
}
