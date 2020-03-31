//
//  Extension.swift
//  StayHome
//
//  Created by Enrico Castelli on 22/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var navigation: Navigation {
        return self.navigationController as! Navigation
    }
}

extension UIView {

    func setConstraint(constraint: NSLayoutConstraint.Attribute, constant: CGFloat) {
        guard let superview = superview else { return }
        if translatesAutoresizingMaskIntoConstraints == true {
            translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.init(item: self,
                                attribute: constraint,
                                relatedBy: .equal,
                                toItem: superview,
                                attribute: constraint,
                                multiplier: 1,
                                constant: constant).isActive = true
    }
    
    func setSelfConstraint(constraint: NSLayoutConstraint.Attribute, constant: CGFloat) {
        if translatesAutoresizingMaskIntoConstraints == true {
            translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .height,
                                         multiplier: 1,
                                         constant: constant))
    }
    
    
    func setAspectRatio(_ w: Float, _ h: Float) {
        if translatesAutoresizingMaskIntoConstraints == true {
            translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .width,
                                         multiplier: CGFloat(w/h),
                                         constant: 0))
    }
    
    
    func addContentView(_ contentView: UIView, _ atIndex: Int? = nil) {
        let containerView = self
        contentView.translatesAutoresizingMaskIntoConstraints = false
        if let atIndex = atIndex {
            containerView.insertSubview(contentView, at: atIndex)
        } else {
            containerView.addSubview(contentView)
        }
        NSLayoutConstraint.init(item: contentView,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: containerView,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: contentView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: containerView,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: contentView,
                                attribute: .right,
                                relatedBy: .equal,
                                toItem: containerView,
                                attribute: .right,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: contentView,
                                attribute: .left,
                                relatedBy: .equal,
                                toItem: containerView,
                                attribute: .left,
                                multiplier: 1,
                                constant: 0).isActive = true
    }
    
    func copyView<T:UIView>() -> T? {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false) {
            return try? (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T)
        }
        return nil
    }
}

extension String {
    
    var playerName: String {
        let nameString = self.replacingOccurrences(of: "iPhone", with: "").replacingOccurrences(of: "'s", with: "").replacingOccurrences(of: "di", with: "").replacingOccurrences(of: " ", with: "")
        guard nameString != "" && nameString != " " && nameString.count < 60 else { return "iPhone" }
        return nameString
    }
}


extension Double {
    var toString: String {
        return String(format: "%.1f", self).replacingOccurrences(of: ".", with: ",")
    }
    
    var toCounterString: String {
        var string = String(format: "%.1f", self).replacingOccurrences(of: ".", with: ",")
        if string.count == 3 {
            string = "0\(string)"
        }
        return string
    }
}

extension UICollectionViewCell  {
    
    func frameInSuperview() -> CGRect {
        return self.superview?.convert(self.frame, to: nil) ?? .zero
    }
}

extension UITableViewCell  {
    
    func frameInSuperview() -> CGRect {
        return self.superview?.convert(self.frame, to: nil) ?? .zero
    }
}

extension UIColor {
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension UILayoutPriority {
    
    static let high = UILayoutPriority(rawValue: 999)
    static let low = UILayoutPriority(rawValue: 1)

}

enum GestureDirection: Int {
    case Up
    case Down
    case Left
    case Right

    public var isX: Bool { return self == .Left || self == .Right }
    public var isY: Bool { return !isX }
}

extension UIPanGestureRecognizer {

    var direction: GestureDirection? {
        let vel = velocity(in: view)
        let vertical = abs(vel.y) > abs(vel.x)
        switch (vertical, vel.x, vel.y) {
        case (true, _, let y) where y < 0: return .Up
        case (true, _, let y) where y > 0: return .Down
        case (false, let x, _) where x > 0: return .Right
        case (false, let x, _) where x < 0: return .Left
        default: return nil
        }
    }
}

extension Int {
    var string: String {
        return String(self)
    }
}
