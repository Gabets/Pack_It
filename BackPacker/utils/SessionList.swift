//
//  SessionList.swift
//  BackPacker
//
//  Created by Alex Gabets on 22.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import Foundation

class SessionList {
    
    static var currentList: ObjectList? = nil
    
    static func setCurrentList(_ list: ObjectList) {
        self.currentList = list
    }
    
    static func getCurrentList() -> ObjectList? {
        return currentList
    }
}
