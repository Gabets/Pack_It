//
//  ObjectListItem.swift
//  BackPacker
//
//  Created by Alex Gabets on 19.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import Foundation
import RealmSwift

// Dog model
class ObjectListItem: Object {
    @objc dynamic var name = ""
    @objc dynamic var isPacked = false
}
