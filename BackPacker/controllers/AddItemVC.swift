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
    

    @IBOutlet weak var barTitle: UINavigationItem!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableItems: UITableView!
    
    private let cellReuseIdentifier = "AddItemCell"
    
    var updateCallback : (()->())?
    
    private let realm = try! Realm()
    private var currentList: ObjectList?
    private var listItems: Results<ObjectListName>?
    private var sortedListItems: [String] = []
    private var filteredListItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentList = SessionList.getCurrentList()
        barTitle.title = currentList?.listName
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
        cell.buttonDelete.tag = indexPath.row
        cell.buttonDelete.addTarget(self, action: #selector(clickDeleteItem(sender:)), for: .touchUpInside)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
//        cell.textLabel?.text = filteredListItems[indexPath.row]
        
        return cell
    }
    
    
    // MARK: - Actions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\n LOG \(filteredListItems[indexPath.row])")
        
        let objectItem = ObjectListItem()
        objectItem.name = filteredListItems[indexPath.row]
        objectItem.id = (currentList?.countValue)!
        
        try! realm.write {
            currentList?.listItems.append(objectItem)
            currentList?.countValue += 1
        }
        
        self.view.makeToast("\(filteredListItems[indexPath.row]) добавлено", duration: 2.0, position: .center)
        updateCallback!()
    }
    
    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchText  = textField.text!
    
        if searchText.isEmpty {
            filteredListItems = sortedListItems
        } else {
            filteredListItems = sortedListItems.filter({
                $0.contains(searchText.lowercased())
            })
        }
                
        tableItems.reloadData()
    }
    
    @objc func clickDeleteItem(sender : UIButton) {
        
        guard let index = listItems!.index(of: (listItems!.first(where: {
            $0.name == filteredListItems[sender.tag]
        }))!) else {
            return
        }
       
        let itemObject = listItems![index]
        try! realm.write {
            realm.delete(itemObject)
            self.view.makeToast("Удалено \(filteredListItems[sender.tag])", duration: 2.0, position: .center)
        }
        
        prepareList()
        tableItems.reloadData()
    }
    
    
    // MARK: - Other
    func prepareList() {
        
//        try! realm.write {
//            realm.deleteAll()
//        }
        sortedListItems.removeAll()
        listItems = realm.objects(ObjectListName.self)
        
//        print("\n LOG listItems count = \(String(describing: listItems?.count))")
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
    }
    
}
