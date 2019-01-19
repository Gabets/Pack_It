//
//  AddItemVC.swift
//  BackPacker
//
//  Created by Alex Gabets on 08.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit
import RealmSwift

class AddItemVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var barTitle: UINavigationItem!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableItems: UITableView!
    
    private var listItems: Results<ObjectListItem>?
    private var sortedListItems: [String] = []
    private var filteredListItems: [String] = []
    var listTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barTitle.title = listTitle
        tfSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        prepareList()
    }
    
    // MARK: - Table methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = filteredListItems[indexPath.row]
        
        return cell
    }
    
    
    // MARK: - Actions
    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchText  = textField.text!
    
        filteredListItems = sortedListItems.filter({
            $0.contains(searchText)
        })
        
        tableItems.reloadData()
    }
    
    
    // MARK: - Other
    func prepareList() {
        let realm = try! Realm()
        listItems = realm.objects(ObjectListItem.self)
        
        if listItems!.count == 0 {
            let constantItems = ConstantsItems()
            for item in constantItems.items {
                let objectItem = ObjectListItem()
                objectItem.name = item
                try! realm.write {
                    realm.add(objectItem)
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
