//
//  ListCollectionCell.swift
//  BackPacker
//
//  Created by Alex Gabets on 05.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

class ListCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var labelDate: UILabel!
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
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
    }
    
    func setupCell(_ cellData: CellList, imageWidth: CGFloat) {
        imageTitle.image = cellData.imageTitle
        self.percent = cellData.textPercent ?? 0.0
        self.imageWidth = imageWidth - 40
        self.progressWidth = imageWidth - 40

        if cellData.timerDate != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.TIMER_FORMAT
            labelDate.text = dateFormatter.string(from: cellData.timerDate!).lowercased()
        } else {
            labelDate.text = ""
        }

        labelTitle.text = cellData.textTitle
        labelDescription.text = cellData.textDescription
        labelPercent.text = "\(Int(percent.rounded()))%"
        
        addProgressArc()
    }
    
    private func addProgressArc() {
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
        removeArc()
    }
    
    func removeArc() {
        if (self.subviews.last as? ProgressArcView) != nil  {
            self.subviews.last?.removeFromSuperview()
        }
    }
}
