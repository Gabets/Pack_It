//
//  ProgressArcView.swift
//  BackPacker
//
//  Created by Alex Gabets on 15.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

class ProgressArcView: UIView {
    private let arcColor = UIColor(red: 74 / 255, green: 209 / 255, blue: 243 / 255, alpha: 1.0)
    
    private var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.darkGray
        
        createShapeLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createArc() {
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2),
                            radius: self.frame.size.height / 2 - Constants.ARC_LINE_WIDTH / 2,
                            startAngle: CGFloat(350.0).toRadians(),
                            endAngle: CGFloat(0.0).toRadians(),
                            clockwise: false)
    }
    
    func createShapeLayer() {
        self.createArc()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = self.path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = arcColor.cgColor
        shapeLayer.lineWidth = Constants.ARC_LINE_WIDTH
        shapeLayer.lineCap = .round
        
        self.layer.addSublayer(shapeLayer)
        self.backgroundColor = arcColor
        self.layer.mask = shapeLayer
    }

}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * .pi / 180.0
    }
}
