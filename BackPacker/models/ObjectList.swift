//
//  ObjectList.swift
//  BackPacker
//
//  Created by Alex Gabets on 20.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import Foundation
import RealmSwift

class ObjectList: Object {
    @objc dynamic var imageName = ""
    @objc dynamic var listName = ""
    @objc dynamic var listDescription = ""
    @objc dynamic var countValue = 0
    
    var listItems = List<ObjectListItem>()
    
    override static func primaryKey() -> String? {
        return "listName"
    }
}
