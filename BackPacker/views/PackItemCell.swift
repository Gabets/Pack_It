//
//  PackItemCell.swift
//  BackPacker
//
//  Created by Alex Gabets on 18.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

class PackItemCell: UITableViewCell {
    
    @IBOutlet weak var imageRound: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonDelete: NSLayoutConstraint!
    
    private let imagePacked: UIImage = UIImage(imageLiteralResourceName: "round button fill")
    private let imageUnPacked: UIImage = UIImage(imageLiteralResourceName: "round button")
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(name: String, isPacked: Bool) {
        labelName.text = name
        
        if isPacked {
            imageRound.image = imagePacked
        } else {
            imageRound.image = imageUnPacked
        }
    }
    
}
