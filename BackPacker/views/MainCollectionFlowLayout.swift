//
//  MainCollectionFlowLayout.swift
//  BackPacker
//
//  Created by Alex Gabets on 16.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

class MainCollectionFlowLayout: UICollectionViewFlowLayout {
    
    var screenSize: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()

        scrollDirection = .horizontal
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x
        let targetRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: self.collectionView!.bounds.size)
        
        for layoutAttributes in super.layoutAttributesForElements(in: targetRect)! {
            let itemOffset = layoutAttributes.frame.origin.x
            if abs(itemOffset - horizontalOffset) < abs(offsetAdjustment) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }
       
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment - screenSize / 5,
                       y: proposedContentOffset.y)
    }

}
