//
//  AddItemVC.swift
//  BackPacker
//
//  Created by Alex Gabets on 08.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit
import RealmSwift
import Toast_Swift

class AddItemVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var navItemBack: UIBarButtonItem!
    @IBOutlet weak var barTitle: UINavigationItem!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableItems: UITableView!
    @IBOutlet weak var buttonCreate: UIButton!
    @IBOutlet weak var constraintButtonAdd: NSLayoutConstraint!
    
    private let cellReuseIdentifier = "AddItemCell"
    
    var updateCallback : (()->())?
    
    private let realm = try! Realm()
    private var currentList: ObjectList?
    private var listItems: Results<ObjectListName>?
    private var sortedListItems: [String] = []
    private var filteredListItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navItemBack.title = "navigation_back".localized
        tfSearch.placeholder = "add_item_placeholder".localized
        
        buttonCreate.isEnabled = false
        buttonCreate.isHidden = true
        constraintButtonAdd.constant = 0
        
        currentList = SessionList.getCurrentList()
        barTitle.title = currentList?.listName
        
        tfSearch.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tfSearch.frame.height))
        tfSearch.leftViewMode = .always
        tfSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
       
        tableItems.register(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
      
        prepareList()
    }
    
    // MARK: - Table methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableItems.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AddItemCell
        cell.labelName.text = filteredListItems[indexPath.row]
        
        return cell
    }
    
    
    // MARK: - Actions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        addItemToList(filteredListItems[indexPath.row], false)
    }
    
    @IBAction func clickAdd(_ sender: UIButton) {
        guard let name = tfSearch.text else {
            return
        }
        
        let itemNameObject = ObjectListName()
        itemNameObject.name = name
        
        addItemToList(name, true)
    }
    
    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchText = textField.text!
    
        if searchText.isEmpty {
            filteredListItems = sortedListItems
            buttonCreate.isEnabled = false
            buttonCreate.isHidden = true
            constraintButtonAdd.constant = 0
        } else {
            filterList(searchText)
            
            if filteredListItems.count == 0 {
                buttonCreate.isEnabled = true
                buttonCreate.isHidden = false
                constraintButtonAdd.constant = 30
            } else {
                buttonCreate.isEnabled = false
                buttonCreate.isHidden = true
                constraintButtonAdd.constant = 0
            }
        }
                
        tableItems.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = filteredListItems[indexPath.row]
        
        let delete = UIContextualAction(style: .destructive, title: "add_item_title_delete".localized) { (action, view, nil) in
            self.deleteItemFromDB(item)
        }
        
        let img: UIImage = UIImage(named: "basket3x")!
        
        delete.image = img
        delete.backgroundColor = UIColor(red: 250 / 255, green: 123 / 255, blue: 100 / 255, alpha: 1.0)
        let config =  UISwipeActionsConfiguration(actions: [delete])
        return config
    }
    
    // MARK: - Other
    private func addItemToList(_ itemName: String, _ isCreated: Bool) {
        
        let objectItem = ObjectListItem()
        objectItem.name = itemName
        objectItem.id = (currentList?.countValue)!
        
        try! realm.write {
            if isCreated {
                let objectItemName = ObjectListName()
                objectItemName.name = itemName
                realm.add(objectItemName, update: true)
            }
            
            currentList?.listItems.append(objectItem)
            currentList?.countValue += 1
            
            if isCreated {
                self.view.makeToast("\(itemName) \("add_item_toast_created_and_added".localized)", duration: 2.0, position: .center)
                self.filteredListItems.append(itemName)
                self.prepareList()
                self.tableItems.reloadData()
            } else {
               self.view.makeToast("\(itemName) \("add_item_toast_added".localized)", duration: 2.0, position: .center)
            }
            
            self.updateCallback!()
        }
    }
    
    private func deleteItemFromDB(_ name: String) {
        guard let index = listItems!.index(of: (listItems!.first(where: {
            $0.name == name
        }))!) else {
            return
        }
        
        let itemObject = listItems![index]
        try! realm.write {
            realm.delete(itemObject)
            self.view.makeToast("\(name) \("add_item_toast_deleted".localized)", duration: 2.0, position: .center)
        }
        
        prepareList()
        tableItems.reloadData()
    }
    
    func prepareList() {
        
//        try! realm.write {
//            realm.deleteAll()
//        }
        sortedListItems.removeAll()
        listItems = realm.objects(ObjectListName.self)
        
        if listItems!.count == 0 {
            let constantItems = ConstantsItems()
            let allItems = constantItems.itemsBeach + constantItems.itemsBusiness + constantItems.itemsForest
            for item in allItems {
                let objectItem = ObjectListName()
                objectItem.name = item.lowercased()
                try! realm.write {
                    realm.add(objectItem, update: true)
                }
            }
        }

        for item in listItems! {
            sortedListItems.append(item.name)
        }
        sortedListItems.sort(by: {
            $0.lowercased() < $1.lowercased()
        })
        
        filteredListItems = sortedListItems
        
        guard let searchText = tfSearch.text else {
            return
        }
        if !searchText.isEmpty {
            filterList(searchText)
        }
    }
    
    private func filterList(_ searchText: String) {
        filteredListItems = sortedListItems.filter({
            $0.contains(searchText.lowercased())
        })
    }

}
