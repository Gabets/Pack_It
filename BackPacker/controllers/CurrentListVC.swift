//
//  CirrentListVC.swift
//  BackPacker
//
//  Created by Alex Gabets on 05.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit
//import SwipeCellKit

class CurrentListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var navItemBack: UIBarButtonItem!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var segmentFilter: UISegmentedControl!
    @IBOutlet weak var tableItems: UITableView!
    
    private let cellReuseIdentifier = "PackItemCell"
    private let colorNavigation = UIColor(red: 250 / 255, green: 123 / 255, blue: 100 / 255, alpha: 1.0)

    var listTitle = ""
    private var filterIndex = 0
    private var packItemsList: [ListItem] = []
    private var sortedItemsList: [ListItem] = []
    private var filteredItemsList: [ListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableItems.register(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        packItemsList.append(ListItem(name: "Тушёнка", isPacked: false))
        packItemsList.append(ListItem(name: "Аптечка", isPacked: true))
        packItemsList.append(ListItem(name: "нож", isPacked: true))
        packItemsList.append(ListItem(name: "спальник", isPacked: false))
        packItemsList.append(ListItem(name: "спички", isPacked: false))
        
        navTitle.title = listTitle
        navItemBack.title = "Назад"

        sortedItemsList = packItemsList.sorted(by: {
            $0.name.lowercased() < $1.name.lowercased()
        })
        filteredItemsList = sortedItemsList
        
        self.title = listTitle
    }
    
    
    // MARK: - Table data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItemsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableItems.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PackItemCell
        let item = filteredItemsList[indexPath.row]
        cell.setupCell(name: item.name, isPacked: item.isPacked)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = filteredItemsList[indexPath.row].name
        for i in 0..<sortedItemsList.count {
            if sortedItemsList[i].name == name {
                sortedItemsList[i].isPacked = !sortedItemsList[i].isPacked
                break
            }
        }

        filterCurrentList()
    }
    
    // MARK: - Actions
    @IBAction func clickBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickAdd(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddItemVC") as! AddItemVC
        vc.listTitle = listTitle
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func clickEdit(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditListVC") as! EditListVC
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func changeFilter(_ sender: UISegmentedControl) {
        filterIndex = sender.selectedSegmentIndex
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
    
}
