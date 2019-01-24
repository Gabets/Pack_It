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
    private let imageForest = UIImage(named: "img_1")
    private let imageNepal = UIImage(named: "img_1")
    private let imageRiver = UIImage(named: "img_1")
    private let cellNib = UINib(nibName: "ListCollectionCell", bundle: nil)
    
    private var lists: Results<ObjectList>?
    private var cellsData: [CellList] = []
    private var screenWidth: CGFloat = 0
    private var screenHeight: CGFloat = 0
    
    private var pageInt = 0
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellId)
        prepareLists()
        
        screenWidth = UIScreen.main.bounds.width
        screenHeight = screenWidth * 9 / 5
        print("\n screenWidth = \(screenWidth)")
        
        collectionView.contentInset.left = screenWidth / 7
        collectionView.contentInset.right = screenWidth / 7
        collectionView.contentInset.bottom = screenHeight / 9
        
        let flowLayout = collectionView.collectionViewLayout as! MainCollectionFlowLayout
        flowLayout.screenSize = screenWidth
       
        pageControl.numberOfPages = cellsData.count
        pageControl.currentPage = 0

    }
    
    override func viewDidAppear(_ animated: Bool) {
        SessionList.setCurrentList((lists?.last)!)
    }
    
    // MARK: UICollectionViewDataSource
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
    
    
    // MARK: - Navigation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = self.collectionView.cellForItem(at: indexPath) as! ListCollectionCell
        cell.removeArc()
        
        if indexPath.row == cellsData.count - 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditListVC") as! EditListVC
            vc.isCreate = true
            self.navigationController?.present(vc, animated: true, completion: nil)
        } else {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentListVC") as! CurrentListVC
            vc.percentCallback = {
                self.prepareLists()
                self.collectionView.reloadData()
            }
            
            SessionList.setCurrentList(
                (lists?.first(where: {item in
                    item.listName == self.cellsData[indexPath.row].textTitle
                }))!
            )
            
            vc.modalTransitionStyle = .coverVertical
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        pageControl.currentPage = Int(((offSetX + horizontalCenter) / width).rounded())
    }
    
    // MARK: - Other
    private func prepareLists() {
        cellsData.removeAll()
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        
        let realm = try! Realm()
//        try! realm.write {
//            realm.deleteAll()
//        }
        
        lists = realm.objects(ObjectList.self)
        
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
            
            cellsData.append(CellList.init(imageTitle: UIImage(named: item.imageName),
                                           textTitle: item.listName,
                                           textPercent: percent,
                                           textDescription: item.listDescription))
        }
    }

}
