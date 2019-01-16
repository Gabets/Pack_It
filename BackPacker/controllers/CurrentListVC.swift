//
//  CirrentListVC.swift
//  BackPacker
//
//  Created by Alex Gabets on 05.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

class CurrentListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var segmentFilter: UISegmentedControl!
    @IBOutlet weak var tableItems: UITableView!
    
    private let cellReuseIdentifier = "cell"

    var listTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableItems.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        self.title = listTitle
    }
    
    
    // MARK: - Table data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell: UITableViewCell = tableItems.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell

        return cell
    }
    
    
    @IBAction func clickAdd(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddItemVC") as! AddItemVC
        vc.barTitleText = listTitle
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
}
