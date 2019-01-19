//
//  ListCollectionCell.swift
//  BackPacker
//
//  Created by Alex Gabets on 05.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

class ListCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var labelPercent: UILabel!
    @IBOutlet weak var imageTitle: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    private var imageWidth: CGFloat = 0
    private var progressWidth: CGFloat = 0
    private var percent: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10.0
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5.0)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.5
        layer.masksToBounds = false
    }
    
    func setupCell(_ image: UIImage, title: String, listDescription: String, percent: CGFloat, imageWidth: CGFloat) {
        imageTitle.image = image
        self.percent = percent
        self.imageWidth = imageWidth - 80
        self.progressWidth = imageWidth - 30
        
        labelTitle.text = title
        labelDescription.text = listDescription
        labelPercent.text = "\(Int(percent.rounded()))%"
        
        addProgressArc()
    }
    
    func addProgressArc() {
        let progressArcView = ProgressArcView(frame: CGRect(x: self.frame.size.width / 2 - progressWidth / 2 - Constants.ARC_LINE_WIDTH / 2,
                                                            y: 50 - Constants.ARC_LINE_WIDTH / 2,
                                                            width: progressWidth + Constants.ARC_LINE_WIDTH,
                                                            height: progressWidth + Constants.ARC_LINE_WIDTH), percent: percent)
       
        self.addSubview(progressArcView!)
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
