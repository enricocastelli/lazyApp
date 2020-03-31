//
//  TabView.swift
//  StayHome
//
//  Created by Enrico Castelli on 23/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

protocol TabViewDelegate {
    func didTapIndex(_ index: Int)
}

class TabView: NibView {
    
    @IBOutlet weak var stack: UIStackView!
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
   
    var delegate: TabViewDelegate?
    
    override func nibSetup() {
        super.nibSetup()
    }
    
    @IBAction func leftTapped(_ sender: Any) {
        delegate?.didTapIndex(0)
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        delegate?.didTapIndex(1)
    }
    
    @IBAction func rightTapped(_ sender: Any) {
        delegate?.didTapIndex(2)
    }
}
