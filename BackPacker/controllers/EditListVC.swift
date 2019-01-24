//
//  EditListVC.swift
//  BackPacker
//
//  Created by Alex Gabets on 19.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit
import RealmSwift
import Toast_Swift

class EditListVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var navBack: UIBarButtonItem!
    @IBOutlet weak var navSave: UIBarButtonItem!
    @IBOutlet weak var buttonImage: UIButton!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var constraintHeightDescription: NSLayoutConstraint!
    @IBOutlet weak var buttonCopy: UIButton!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    
    private let MAX_COUNT_NAME = 30
    private let MAX_COUNT_DESCRIPTION = 30
    private let realm = try! Realm()
    
    var clearCallback : (()->())?
    var isCreate = false
    
    private var currentList: ObjectList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentList = SessionList.getCurrentList()

        navTitle.title = "Редактирование"
        if isCreate {
            navTitle.title = "Создание"
        }
        
        navBack.title = "Назад"
        navSave.title = "Сохр."
        
        buttonImage.setImage(UIImage(named: (currentList?.imageName)!), for: .normal)
        buttonImage.imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
        
        tfName.delegate = self
        tfName.text = currentList?.listName
        
        tvDescription.delegate = self
        tvDescription.text = currentList?.listDescription
        constraintHeightDescription.constant = self.tvDescription.contentSize.height
    }
    
    // MARK: - Actions
    @IBAction func clickBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickSave(_ sender: UIBarButtonItem) {
        var style = ToastStyle()
        style.messageAlignment = .center
        
        if (tfName.text?.isEmpty)! {
            self.view.makeToast("Введите название списка!", duration: 3.0, position: .center)
            return
        }
        
        if let existingList = realm.object(ofType: ObjectList.self, forPrimaryKey: tfName.text) {
            self.view.makeToast("Список \"\(existingList.listName)\" уже существует", duration: 3.0, position: .center, style: style)
        } else {
            self.view.makeToast("Список \"\(tfName.text ?? ""))\" создан", duration: 3.0, position: .center, style: style)
        }
    }
    
    @IBAction func clickImage(_ sender: UIButton) {
        print("\n LOG clickImage")
    }
    
    @IBAction func clickCopy(_ sender: UIButton) {
        if isCreate {
            self.view.makeToast("Недоступно при создании", duration: 2.0, position: .center)
            return
        }
    }
    
    @IBAction func clickClear(_ sender: UIButton) {
        if isCreate {
            self.view.makeToast("Недоступно при создании", duration: 2.0, position: .center)
            return
        }
        
        try! realm.write {
            currentList?.listItems.removeAll()
            self.clearCallback!()
            self.view.makeToast("Список очищен", duration: 2.0, position: .center)
        }
    }
    
    @IBAction func clickDelete(_ sender: UIButton) {
        if isCreate {
            self.view.makeToast("Недоступно при создании", duration: 2.0, position: .center)
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= MAX_COUNT_NAME
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= MAX_COUNT_DESCRIPTION
    }
    
}
