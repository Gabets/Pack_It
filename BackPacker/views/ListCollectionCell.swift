//
//  ListCollectionCell.swift
//  BackPacker
//
//  Created by Alex Gabets on 05.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

class ListCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var imageTitle: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    private var imageWidth: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(_ image: UIImage, title: String, timerText: String, imageWidth: CGFloat) {
        imageTitle.image = image
        self.imageWidth = imageWidth - 30
        
        labelTitle.text = title
        labelTimer.text = timerText
        
        addProgressArc()
    }
    
    func addProgressArc() {
        let progressArcView = ProgressArcView(frame: CGRect(x: self.frame.size.width / 2 - imageWidth / 2 - Constants.ARC_LINE_WIDTH / 2,
                                                            y: 50 - Constants.ARC_LINE_WIDTH / 2,
                                                            width: imageWidth + Constants.ARC_LINE_WIDTH,
                                                            height: imageWidth + Constants.ARC_LINE_WIDTH))
       
        self.addSubview(progressArcView)
    }
    
    func updateCornerRadius() {
        imageTitle.layer.cornerRadius = (imageWidth / 2)
        imageTitle.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateCornerRadius()
        
    }
}
