//
//  CirrentListVC.swift
//  BackPacker
//
//  Created by Alex Gabets on 05.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit
import RealmSwift

class CurrentListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var navItemBack: UIBarButtonItem!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var segmentFilter: UISegmentedControl!
    @IBOutlet weak var tableItems: UITableView!
    
    var percentCallback : (()->())?
    
    private let realm = try! Realm()
    private let cellReuseIdentifier = "PackItemCell"
    private let colorNavigation = UIColor(red: 250 / 255, green: 123 / 255, blue: 100 / 255, alpha: 1.0)

    private var currentList: ObjectList?
    private var filterIndex = 0
    private var sortedItemsList: [ObjectListItem] = []
    private var filteredItemsList: [ObjectListItem] = []
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableItems.register(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        currentList = SessionList.getCurrentList()
        navTitle.title = currentList?.listName
        navItemBack.title = "Назад"
       
        self.title = currentList?.listName
        
        updateTable()
    }
    
    
    // MARK: - Table data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItemsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableItems.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PackItemCell
        let item = filteredItemsList[indexPath.row]
        cell.setupCell(name: item.name, isPacked: item.isPacked)
        
        cell.buttonRound.tag = item.id
        cell.buttonRound.addTarget(self, action: #selector(clickPackItem(sender:)), for: .touchUpInside)
        cell.buttonDelete.tag = item.id
        cell.buttonDelete.addTarget(self, action: #selector(clickDeleteItem(sender:)), for: .touchUpInside)

        return cell
    }
    
    // MARK: - Actions
    @IBAction func clickBack(_ sender: UIBarButtonItem) {
        percentCallback!()
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickAdd(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddItemVC") as! AddItemVC
        vc.modalTransitionStyle = .crossDissolve
        vc.updateCallback = {
            self.updateTable()
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func clickEdit(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditListVC") as! EditListVC
        vc.clearCallback = {
            self.updateTable()
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func changeFilter(_ sender: UISegmentedControl) {
        filterIndex = sender.selectedSegmentIndex
        filterCurrentList()
    }
    
    @objc func clickPackItem(sender : UIButton) {
//        let name = filteredItemsList[sender.tag].name
        for i in 0..<sortedItemsList.count {
            if sortedItemsList[i].id == sender.tag {
                try! realm.write {
                    sortedItemsList[i].isPacked = !sortedItemsList[i].isPacked
                }
                
                break
            }
        }
        
        filterCurrentList()
    }
    
    @objc func clickDeleteItem(sender : UIButton) {
        guard let index = currentList?.listItems.index(of: (currentList?.listItems.first(where: {
            $0.id == sender.tag
        }))!) else {
            return
        }
        
        try! realm.write {
            currentList?.listItems.remove(at: index)
            sortedItemsList.remove(at: index)
        }
     
        filterCurrentList()
    }
    
    // MARK: - Other
    private func filterCurrentList() {
        
        switch filterIndex {
        case 1:
            filteredItemsList = sortedItemsList.filter({ !$0.isPacked })
        case 2:
            filteredItemsList = sortedItemsList.filter({ $0.isPacked })
        default:
            filteredItemsList = sortedItemsList
        }
        
        tableItems.reloadData()
    }
    
    func updateTable() {
        sortedItemsList = Array((currentList?.listItems)!).sorted(by: {
            $0.name.lowercased() < $1.name.lowercased()
        })
        filteredItemsList = sortedItemsList
        
        tableItems.reloadData()
    }
    
}
