//
//  MainCollectionVC.swift
//  BackPacker
//
//  Created by Alex Gabets on 07.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit
import RealmSwift

class MainCollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let cellId = "CellList"
    private let cellNib = UINib(nibName: "ListCollectionCell", bundle: nil)
    private lazy var realm = try! Realm()
    
    private var lists: Results<ObjectList>?
    private var cellsData: [CellList] = []
    private var screenWidth: CGFloat = 0
    private var screenHeight: CGFloat = 0
    
    private var pageInt = 0
    private var isCallback = true
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellId)
        prepareLists()
        
        screenWidth = UIScreen.main.bounds.width
        
        let flowLayout = collectionView.collectionViewLayout as! MainCollectionFlowLayout
        flowLayout.screenSize = screenWidth
        
        screenHeight = screenWidth * 9 / 5
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: screenWidth / 7, bottom: screenHeight / 9, right: screenWidth / 7)
       
        pageControl.currentPage = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        SessionList.setCurrentList(lists?.last)
        updateScreen()
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return cellsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ListCollectionCell
        
        let cellData = cellsData[indexPath.row]
        cell.labelPercent.isHidden = false
        cell.buttonDelete.isHidden = false
        cell.buttonDelete.tag = indexPath.row
        cell.buttonDelete.addTarget(self, action: #selector(clickDelete(sender:)), for: .touchUpInside)
        if indexPath.row == cellsData.count - 1 {
            cell.buttonDelete.isHidden = true
            cell.labelPercent.isHidden = true
        }
        
        cell.setupCell(cellData, imageWidth: cell.layer.bounds.width)
        cell.updateCornerRadius()
        
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth * 5 / 7, height: screenHeight * 5 / 7.5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return screenWidth / 10
    }
    
    //MARK: - Actions
    @objc func clickDelete(sender : UIButton) {
        
        let alertController = UIAlertController(title: "main_screen_alert_title".localized, message: "", preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: "button_cancel".localized, style: .default) { (action:UIAlertAction) in
        }
        
        let actionDelete = UIAlertAction(title: "button_delete".localized, style: .destructive) { (action:UIAlertAction) in
            
            if let objectForRemove = self.lists?.first(where: {item in
                item.listName == self.cellsData[sender.tag].textTitle
            }) {
                try! self.realm.write {
                    self.realm.delete(objectForRemove)
                }
                
                self.updateScreen()
            }
        }

        alertController.addAction(actionCancel)
        alertController.addAction(actionDelete)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath) as! ListCollectionCell
        cell.removeArc()
        
        if indexPath.row == cellsData.count - 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditListVC") as! EditListVC
            vc.isCreate = true
            vc.updateListsCallback = {
                print("\n TEST updateListsCallback")
                self.prepareLists()
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
            }
            
            self.navigationController?.present(vc, animated: true, completion: nil)
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentListVC") as! CurrentListVC
            vc.percentCallback = { result in
                print("\n TEST percentCallback")
                self.isCallback = result
                self.prepareLists()
                self.collectionView.reloadData()
            }
            
            SessionList.setCurrentList(
                (lists?.first(where: {item in
                    item.listName == self.cellsData[indexPath.row].textTitle
                }))
            )
            
            vc.modalTransitionStyle = .coverVertical
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    

    // MARK: - Navigation
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) {
            pageControl.currentPage = visibleIndexPath.row
        }
    }
    
    // MARK: - Other
    private func updateScreen() {
        print("\n TEST updateScreen isCallback = \(isCallback)")
        if isCallback {
            isCallback = false
            return
        }
        
        print(" TEST updateScreen later")
        prepareLists()
        collectionView.reloadData()
    }
    
    private func prepareLists() {
        cellsData.removeAll()
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true

//        try! realm.write {
//            realm.deleteAll()
//        }
        
        lists = realm.objects(ObjectList.self).sorted(byKeyPath: "timestamp", ascending: false)
        
        if lists?.count == 0 {
            let defaultLists = ConstantsLists()
            for item in defaultLists.lists() {
                
                let objectList = ObjectList()
                objectList.imageName = item.imageName
                objectList.listName = item.listName
                objectList.listDescription = item.listDescription
                objectList.countValue = item.listItems.count
                objectList.listItems = item.listItems

                try! realm.write {
                    realm.add(objectList)
                }
            }
        }

        for item in lists! {
            let allItemsCount: CGFloat = CGFloat(item.listItems.count)
            var packedItemsCount: CGFloat = 0.0
            var percent: CGFloat = 0.0
            
            if allItemsCount > 0 {
                for listItem in item.listItems {
                    if listItem.isPacked {
                        packedItemsCount += 1
                    }
                }
                
                percent = packedItemsCount / allItemsCount * 100.0
            }
            
            cellsData.append(CellList.init(timerDate: item.timerDate,
                                           imageTitle: UIImage(named: item.imageName),
                                           textTitle: item.listName,
                                           textPercent: percent,
                                           textDescription: item.listDescription))
        }
        
        pageControl.numberOfPages = cellsData.count
    }

}
