//
//  ExpandableView.swift
//  StayHome
//
//  Created by Enrico Castelli on 25/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

class ExpandableView: NibView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet var compressConstraints: [NSLayoutConstraint]!
    
    @IBOutlet var expandedConstraints: [NSLayoutConstraint]!
    
    let player: Player
    
    init(player: Player) {
        self.player = player
        super.init(frame: .zero)
    }
    
    override func nibSetup() {
        super.nibSetup()
        placeLabel.text = " "
        imageView.image = LazyAnimal.typeForLevel(player.score).image
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2
        nameLabel.text = player.name
        subtitleLabel.text = player.score.toString
        let animal = LazyAnimal.typeForLevel(player.score)
        lastUpdateLabel.text = player.lastUpdate.readableString()
        progressView.progressTintColor = animal.color
    }
    
    func animateOpening() {
        for constraint in compressConstraints {
            constraint.priority = .low
        }
        for constraint in expandedConstraints {
            constraint.priority = .high
        }
        nameLabel.textAlignment = .center
        subtitleLabel.textAlignment = .center
        lastUpdateLabel.textAlignment = .center
        placeLabel.alpha = 0
        progressView.alpha = 0
        view.layoutIfNeeded()
    }
    
    func animateClosing() {
        nameLabel.textAlignment = .left
        subtitleLabel.textAlignment = .left
        lastUpdateLabel.textAlignment = .left
        for constraint in self.expandedConstraints {
            constraint.priority = .low
        }
        for constraint in self.compressConstraints {
            constraint.priority = .high
        }
        view.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
