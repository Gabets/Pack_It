//
//  AddItemVC.swift
//  BackPacker
//
//  Created by Alex Gabets on 08.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController {

    @IBOutlet weak var barTitle: UINavigationItem!
    
    var barTitleText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barTitle.title = barTitleText

    }

    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }
    
}
