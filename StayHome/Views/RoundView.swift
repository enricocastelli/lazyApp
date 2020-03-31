//
//  RoundView.swift
//  StayHome
//
//  Created by Enrico Castelli on 29/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

class RoundView: UIView {
    
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.height/2
    }
}
