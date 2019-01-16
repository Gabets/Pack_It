//
//  MainCollectionVC.swift
//  BackPacker
//
//  Created by Alex Gabets on 07.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

struct CellList {
    var imageTitle: UIImage?
    var textTitle: String
    var textTimer: String?
}

class MainCollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let cellId = "CellList"
    private let imageForest = UIImage(named: "forest")
    private let imageNepal = UIImage(named: "nepal")
    private let imageRiver = UIImage(named: "river")
    private let cellBorderColorCell = UIColor(red: 121 / 255, green: 121 / 255, blue: 121 / 255, alpha: 1.0)
    private let cellBorderWidth: CGFloat = 2.0
    private let cellNib = UINib(nibName: "ListCollectionCell", bundle: nil)
    
    private var cellsData: [CellList] = []
    private var screenWidth: CGFloat = 0
    private var screenHeight: CGFloat = 0
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellId)
        
        cellsData.append(CellList(imageTitle: imageForest, textTitle: "Forest", textTimer: "21.05 \t 11:00"))
        cellsData.append(CellList(imageTitle: imageNepal, textTitle: "Nepal", textTimer: "22.07 \t 12:00"))
        cellsData.append(CellList(imageTitle: imageRiver, textTitle: "Canoe trip", textTimer: "11.09 \t 22:33"))
        
        screenWidth = UIScreen.main.bounds.width
        screenHeight = screenWidth * 2
        
        collectionView.contentInset.left = screenWidth / 5
        collectionView.contentInset.right = screenWidth / 5
        collectionView.contentInset.bottom = screenHeight / 9
        
        
        
        pageControl.numberOfPages = cellsData.count
        pageControl.currentPage = 0
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
        cell.layer.borderWidth = cellBorderWidth
        cell.layer.borderColor = cellBorderColorCell.cgColor
        
        let cellData = cellsData[indexPath.row]
        cell.setupCell(cellData.imageTitle!, title: cellData.textTitle, timerText: cellData.textTimer!, imageWidth: cell.layer.bounds.width)
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("\n TEST scrollViewWillBeginDragging")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("\n TEST scrollViewDidScroll")
    }

}
