//
//  ButtonExtentions.swift
//  BackPacker
//
//  Created by Alex Gabets on 24.02.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

extension UIButton {
    
    @IBInspectable var xibLocKey: String? {
        get {
            return nil
        }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}
