//
//  LabelExtentions.swift
//  BackPacker
//
//  Created by Alex Gabets on 24.02.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

private var xoAssociationKeyImage: UInt8 = 0

extension UILabel {
    
    @IBInspectable var xibLocKey: String? {
        get {
            return nil
        }
        set(key) {
            if let keyString = key {
                text = keyString.localized
            }
        }
    }
}
