//
//  CreateNewPopupVC.swift
//  BackPacker
//
//  Created by Alex Gabets on 25.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit
import RealmSwift
import Toast_Swift

class CreateNewPopupVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfName: UITextField!
    
    private let realm = try! Realm()
    var createCallback : ((Int, String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfName.delegate = self
        tfName.placeholder = "create_new_popup_placeholder_name".localized
    }
    
    // MARK: - Actions
    @IBAction func clickListType(_ sender: UIButton) {
        var style = ToastStyle()
        style.messageAlignment = .center
        
        if (tfName.text?.isEmpty)! {
            self.view.makeToast("edit_list_toast_empty_list_name".localized, duration: 3.0, position: .center)
            return
        }
        
        if let existingList = realm.object(ofType: ObjectList.self, forPrimaryKey: tfName.text) {
            self.view.makeToast("\("edit_list_toast_list".localized) \"\(existingList.listName)\" \("create_new_popup_list_exist".localized)", duration: 3.0, position: .center, style: style)
            return
        }
        
        createCallback!(sender.tag, tfName.text!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickCancel(_ sender: UIButton) {
        createCallback!(-1, "")
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= Constants.MAX_COUNT_NAME
    }

}
