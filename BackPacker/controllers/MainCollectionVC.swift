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
    private let imageForest = UIImage(named: "forest")
    private let imageNepal = UIImage(named: "nepal")
    private let imageRiver = UIImage(named: "river")
//    private let cellBorderColorCell = UIColor(red: 121 / 255, green: 121 / 255, blue: 121 / 255, alpha: 1.0)
//    private let cellBorderWidth: CGFloat = 2.0
    private let cellNib = UINib(nibName: "ListCollectionCell", bundle: nil)
    
    private var cellsData: [CellList] = []
    private var screenWidth: CGFloat = 0
    private var screenHeight: CGFloat = 0
    
    private var pageInt = 0
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellId)
        
        cellsData.append(CellList(imageTitle: imageForest, textTitle: "На сутки в лес", textPercent: 10.1, textDescription: "В данной списке находятся самые необхожимые предметы для суточного похода в лес"))
        cellsData.append(CellList(imageTitle: imageNepal, textTitle: "Непал", textPercent: 55.5, textDescription: "Снаряжени для поездки в отпуск в Непал"))
        cellsData.append(CellList(imageTitle: imageRiver, textTitle: "Байдарки", textPercent: 88.8, textDescription: "Список для похода на байдарках"))
        
        screenWidth = UIScreen.main.bounds.width
        screenHeight = screenWidth * 2
        print("\n screenWidth = \(screenWidth)")
        
        collectionView.contentInset.left = screenWidth / 5
        collectionView.contentInset.right = screenWidth / 5
        collectionView.contentInset.bottom = screenHeight / 9
        
        let flowLayout = collectionView.collectionViewLayout as! MainCollectionFlowLayout
        flowLayout.screenSize = screenWidth
       
        pageControl.numberOfPages = cellsData.count
        pageControl.currentPage = 0
        
        
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true

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
        cell.setupCell(cellData.imageTitle!, title: cellData.textTitle, listDescription: cellData.textDescription ?? "", percent: cellData.textPercent ?? 0, imageWidth: cell.layer.bounds.width)
        cell.updateCornerRadius()
        
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth * 3 / 5, height: screenHeight * 3 / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return screenWidth / 10
    }
    
    
    // MARK: - Navigation
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CirrentListVC") as! CurrentListVC
        vc.listTitle = cellsData[indexPath.row].textTitle
        vc.modalTransitionStyle = .coverVertical
        self.navigationController?.present(vc, animated: true, completion: nil)
        
//        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        pageControl.currentPage = Int(((offSetX + horizontalCenter) / width).rounded())
    }

}
