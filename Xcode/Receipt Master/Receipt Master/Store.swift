//
//  Receipt.swift
//  Receipt Master
//
//  Created by Luke Chalkley on 25/5/19.
//  Copyright © 2019 Jeremy Chan. All rights reserved.
//

import Foundation
import RealmSwift

class Store : Object{
    @objc dynamic var storeName = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
}
