//
//  ObjectListName.swift
//  BackPacker
//
//  Created by Alex Gabets on 22.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import Foundation
import RealmSwift

class ObjectListName: Object {
    @objc dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
