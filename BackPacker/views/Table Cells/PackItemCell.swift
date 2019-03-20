//
//  PackItemCell.swift
//  BackPacker
//
//  Created by Alex Gabets on 18.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

class PackItemCell: UITableViewCell {
    
    @IBOutlet weak var buttonRound: UIButton!
    @IBOutlet weak var labelName: UILabel!
    
    private let imagePacked: UIImage = UIImage(named: "round button fill")!
    private let imageUnPacked: UIImage = UIImage(named: "round button")!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(name: String, isPacked: Bool) {
        labelName.text = name
        
        if isPacked {
            buttonRound.setImage(imagePacked, for: .normal)
        } else {
            buttonRound.setImage(imageUnPacked, for: .normal)
        }
    }
    
}
