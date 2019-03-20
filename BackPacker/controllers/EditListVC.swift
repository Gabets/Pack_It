//
//  EditListVC.swift
//  BackPacker
//
//  Created by Alex Gabets on 19.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit
import PopupDialog
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
    @IBOutlet weak var constraintUnderlineCopy: NSLayoutConstraint!
    @IBOutlet weak var constraintUnderlineClear: NSLayoutConstraint!
    @IBOutlet weak var timerSwitch: UISwitch!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var constraintLabelDate: NSLayoutConstraint!
    
    private let MAX_COUNT_DESCRIPTION = 120
    private let realm = try! Realm()
    var style = ToastStyle()
    
    var clearCallback: (()->())?
    var updateListsCallback: (()->())?
    var isCreate = false
    
    private var timerDate: Date?
    private var currentList: ObjectList?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navTitle.title = "edit_list_nav_title_editing".localized
        if isCreate {
            navTitle.title = "edit_list_nav_title_creating".localized
        }
        
        navBack.title = "navigation_back".localized
        navSave.title = "navigation_save".localized
        
        constraintUnderlineCopy.constant = 0.5
        constraintUnderlineClear.constant = 0.5

        timerSwitch.layer.cornerRadius = 10.0
        
        setupScreen()
    
        buttonImage.imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
        
        tfName.delegate = self
        tvDescription.delegate = self
    
        style.messageAlignment = .center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isCreate {
            let popupCreateNew = CreateNewPopupVC(nibName: "CreateNewPopupVC", bundle: nil)
            popupCreateNew.createCallback = { tag, name in
                self.setNewList(tag: tag, name: name)
            }
            
            let popup = PopupDialog(viewController: popupCreateNew, tapGestureDismissal: false) {
//                self.isCreate = false

                if SessionList.currentList?.listName == "list_name_new".localized {
                    self.clickBack(self.navBack)
                }
            }
            
            self.present(popup, animated: true, completion: nil)
        }
    }

    
    // MARK: - Actions
    @IBAction func clickBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        if isCreate {
            updateListsCallback!()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickSave(_ sender: UIBarButtonItem) {
        if (tfName.text?.isEmpty)! {
            self.view.makeToast("edit_list_toast_empty_list_name".localized, duration: 3.0, position: .center)
            return
        }
        
        if currentList?.listName == tfName.text! { //if only description was changed
            try! realm.write {
                currentList?.listDescription = self.tvDescription.text
            }
            
        } else { //create list with new name
            let objectNewName = ObjectList()
            objectNewName.listName = tfName.text!
            objectNewName.imageName = currentList!.imageName
            objectNewName.listDescription = currentList!.listDescription
            for item in currentList!.listItems {
                let objectItem = ObjectListItem()
                objectItem.name = item.name
                objectItem.id = objectNewName.countValue
                objectNewName.countValue += 1
                objectNewName.listItems.append(objectItem)
            }
            
            try! realm.write {
                realm.delete(currentList!)
                realm.add(objectNewName, update: true)
            }
            
            currentList = objectNewName
            SessionList.setCurrentList(objectNewName)
            clearCallback!()
        }
        
        self.view.makeToast("\("edit_list_toast_list".localized) \"\(tfName.text ?? "")\" \("edit_list_toast_saved".localized)", duration: 3.0, position: .center, style: style)
    }
    
    @IBAction func clickImage(_ sender: UIButton) {
        let popupSelectImage = SelectImagePopupVC(nibName: "SelectImagePopupVC", bundle: nil)
        popupSelectImage.imageTagCallback = { result in
            self.setSelectedImage(tag: result)
        }
        
        let popup = PopupDialog(viewController: popupSelectImage)
        self.present(popup, animated: true, completion: nil)
    }
    
    @IBAction func setTimer(_ sender: UISwitch) {
        if sender.isOn {
            let popupTimer = TimerPopupVC(nibName: "TimerPopupVC", bundle: nil)
            popupTimer.timerCallback = { timerDate in
                self.setDate(timerDate)
            }
            
            let popup = PopupDialog(viewController: popupTimer)
            self.present(popup, animated: true, completion: nil)
            
        } else {
            try! realm.write {
                currentList?.timerDate = nil
            }
            
            timerDate = nil
            labelDate.text = ""
            constraintLabelDate.constant = 0
        }
    }
    
    @IBAction func clickCopy(_ sender: UIButton) {
        if isCreate {
            self.view.makeToast("edit_list_toast_unavailable_on_creation".localized, duration: 2.0, position: .center)
            return
        }
        
        let objectForCopy = ObjectList()
        objectForCopy.listName = "\("edit_list_name_copy".localized) \(tfName.text ?? "")"
        objectForCopy.imageName = currentList!.imageName
        objectForCopy.listDescription = currentList!.listDescription
        for item in currentList!.listItems {
            let objectItem = ObjectListItem()
            objectItem.name = item.name
            objectItem.id = objectForCopy.countValue
            objectForCopy.countValue += 1
            objectForCopy.listItems.append(objectItem)
        }
        
        try! realm.write {
            realm.add(objectForCopy, update: true)
            self.view.makeToast("\("edit_list_toast_list".localized) \"\(objectForCopy.listName)\" \("edit_list_toast_created".localized)", duration: 3.0, position: .center, style: style)
        }
    }
    
    @IBAction func clickClear(_ sender: UIButton) {
        if isCreate {
            self.view.makeToast("edit_list_toast_unavailable_on_creation".localized, duration: 2.0, position: .center)
            return
        }
        
        try! realm.write {
            currentList?.listItems.removeAll()
            self.clearCallback!()
            self.view.makeToast("edit_list_cleared".localized, duration: 2.0, position: .center)
        }
    }
    
    @IBAction func clickDelete(_ sender: UIButton) {
        if isCreate {
            self.view.makeToast("edit_list_toast_unavailable_on_creation".localized, duration: 2.0, position: .center)
            return
        }
        
        //TODO test delete list
        try! realm.write {
            realm.delete(currentList!)
        }
        
        //TODO move to first screen
//        self.navigationController?.popToRootViewController(animated: true)
        print("\n TEST try to first")
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= Constants.MAX_COUNT_NAME
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= MAX_COUNT_DESCRIPTION
    }
    
    //MARK: - Other
    private func setSelectedImage(tag: Int) {
        var newImageName = ""
        switch tag {
        case 1:
            newImageName = Constants.IMG_NAME_BEACH
        case 2:
            newImageName = Constants.IMG_NAME_BUSINESS
        case 3:
            newImageName = Constants.IMG_NAME_FOREST
        default:
            NSLog("\n LOG Unknown tag = \(tag)")
        }
        
        buttonImage.setImage(UIImage(named: newImageName), for: .normal)
        
        try! realm.write {
            currentList?.imageName = newImageName
        }
    }
    
    private func setNewList(tag: Int, name: String) {
        var selectedList: ObjectList?
        switch tag {
        case 0:
            selectedList = ConstantsLists().listNew
        case 1:
            selectedList = ConstantsLists().listBeach
        case 2:
            selectedList = ConstantsLists().listBusiness
        case 3:
            selectedList = ConstantsLists().listForest
        default:
            return
        }
        
        selectedList?.listName = name
        SessionList.setCurrentList(selectedList!)
        try! realm.write {
            realm.add(selectedList!, update: true)
            self.view.makeToast("\("edit_list_toast_list".localized) \"\(selectedList?.listName ?? "")\" \("edit_list_toast_created".localized)", duration: 2.0, position: .bottom, style: style)
        }
        
        setupScreen()
    }
    
    private func setupScreen() {
        currentList = SessionList.getCurrentList()
        
        buttonImage.setImage(UIImage(named: (currentList?.imageName)!), for: .normal)
        
        tfName.text = currentList?.listName
        tvDescription.text = currentList?.listDescription
        constraintHeightDescription.constant = self.tvDescription.contentSize.height
        
        guard let listDate = currentList?.timerDate else {
            constraintLabelDate.constant = 0
            return
        }
        timerSwitch.setOn(true, animated: false)
        timerDate = listDate
        setScreenDate()
    }
    
    private func setScreenDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.TIMER_FORMAT
        labelDate.text = dateFormatter.string(from: timerDate!)
        constraintLabelDate.constant = 14.5
    }
    
    private func setDate(_ timerDate: Date?) {
        
        guard timerDate != nil else {
            timerSwitch.setOn(false, animated: false)
            return
        }
        
        try! realm.write {
            currentList?.timerDate = timerDate
        }
        
        self.timerDate = timerDate
        setScreenDate()
    }
    
}
