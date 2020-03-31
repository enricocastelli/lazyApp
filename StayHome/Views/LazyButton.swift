//
//  LazyButton.swift
//  StayHome
//
//  Created by Enrico Castelli on 29/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

var no: Bool = true
class LazyButton: UIButton {
        
//    var startPoint: CGPoint { return CGPoint(x: 170, y: 30) }
//    var cp1Point: CGPoint { return CGPoint(x: 280, y: -120) }
//    var cp2Point: CGPoint { return CGPoint(x: -40, y: 30) }
//    var finalPoint: CGPoint { return CGPoint(x: 170, y: 30) }
    var backgroundImageView: UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
   
    private func setup() {
//        layoutIfNeeded()
//        backgroundColor = UIColor.yellow
//        let randomRot = Float(random(min: 0, max: 100)/55)
//        let image = UIImage.shape.tint(.red).rotate(radians: randomRot)
//        backgroundImageView = UIImageView(image: image)
//        backgroundImageView?.contentMode = .scaleAspectFill
//        addContentView(backgroundImageView!, 0)
//        let actualImage = UIImageView(image: self.image(for: .normal))
//        addSubview(actualImage)
//        actualImage.setConstraint(constraint: .leading, constant: 20)
//        actualImage.setConstraint(constraint: .trailing, constant: -20)
//        actualImage.setConstraint(constraint: .bottom, constant: -20)
//        actualImage.setConstraint(constraint: .top, constant: 20)

    }
    
    private func setLayer() {
        let path = UIBezierPath()
        path.move(to:  CGPoint(x: 40.0, y: 240.0))
        path.addCurve(to: CGPoint(x: 160.0, y: 40.0), controlPoint1: CGPoint(x: 50,y: -20), controlPoint2: CGPoint(x: 190, y: 50))
        path.fill()
        path.move(to:  CGPoint(x: 160.0, y: 40.0))
        path.addCurve(to: CGPoint(x: 290, y: 260), controlPoint1: CGPoint(x: 240,y: 60), controlPoint2: CGPoint(x: 310, y: 190))
        path.fill()
        path.move(to:  CGPoint(x: 290.0, y: 260))
        path.addCurve(to: CGPoint(x: 40, y: 240), controlPoint1: CGPoint(x: 280,y: 300), controlPoint2: CGPoint(x: 30, y: 370))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.orange.cgColor
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeLayer.fillRule = .evenOdd
        layer.addSublayer(shapeLayer)
        backgroundColor = UIColor.orange
    }
}
