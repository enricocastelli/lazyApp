//
//  UIImageExtension.swift
//  StayHome
//
//  Created by Enrico Castelli on 23/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

extension UIImage {
    
    static let eagle : UIImage = UIImage(named: "eagle")!
    static let octopus : UIImage = UIImage(named: "octopus")!
    static let goat : UIImage = UIImage(named: "goat")!
    static let owl : UIImage = UIImage(named: "owl")!
    static let panda : UIImage = UIImage(named: "panda")!
    static let pangolin : UIImage = UIImage(named: "pangolin")!
    static let sloth : UIImage = UIImage(named: "sloth")!
    static let squirrel : UIImage = UIImage(named: "squirrel")!
    static let whale : UIImage = UIImage(named: "whale")!
    static let turtle : UIImage = UIImage(named: "turtle")!

    static let shark : UIImage = UIImage(named: "shark")!

    static let instagram : UIImage = UIImage(named: "ig")!
    
    public func tint(_ tint : UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        tint.set()
        withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }

    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
