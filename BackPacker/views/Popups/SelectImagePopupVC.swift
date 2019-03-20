//
//  SelectImagePopupVC.swift
//  BackPacker
//
//  Created by Alex Gabets on 25.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

class SelectImagePopupVC: UIViewController {
    
    @IBOutlet weak var buttonFirst: UIButton!
    @IBOutlet weak var buttonSecond: UIButton!
    @IBOutlet weak var buttonThird: UIButton!
    
    private let borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    var imageTagCallback : ((Int)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonFirst.layer.borderColor = borderColor.cgColor
        buttonFirst.layer.borderWidth = 1.0
        buttonFirst.layer.cornerRadius = 15.0
        
        buttonSecond.layer.borderColor = borderColor.cgColor
        buttonSecond.layer.borderWidth = 1.0
        buttonSecond.layer.cornerRadius = 15.0
        
        buttonThird.layer.borderColor = borderColor.cgColor
        buttonThird.layer.borderWidth = 1.0
        buttonThird.layer.cornerRadius = 15.0
        
    }

    // MARK: - Navigation
    @IBAction func clickButtonImage(_ sender: UIButton) {
        imageTagCallback!(sender.tag)
        dismiss(animated: true, completion: nil)
    }
    
}
