//
//  EditListVC.swift
//  BackPacker
//
//  Created by Alex Gabets on 19.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

class EditListVC: UIViewController {
    
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var navBack: UIBarButtonItem!
    @IBOutlet weak var navSave: UIBarButtonItem!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var constraintHeightDescription: NSLayoutConstraint!
    @IBOutlet weak var buttonCopy: UIButton!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navTitle.title = "Редактирование"
        navBack.title = "Назад"
        navSave.title = "Сохр."

        constraintHeightDescription.constant = self.tvDescription.contentSize.height
    }
    
    // MARK: - Actions
    @IBAction func clickBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickSave(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func clickImage(_ sender: UIButton) {
    }
    
    @IBAction func clickCopy(_ sender: UIButton) {
    }
    
    @IBAction func clickClear(_ sender: UIButton) {
    }
    
    @IBAction func clickDelete(_ sender: UIButton) {
    }
}
