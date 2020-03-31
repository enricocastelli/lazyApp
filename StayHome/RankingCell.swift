//
//  RankingCell.swift
//  StayHome
//
//  Created by Enrico Castelli on 23/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

class RankingCell: UITableViewCell {

    static let identifier = String(describing: RankingCell.self)
    var expandableView: ExpandableView?
    
    var player: Player? {
        didSet {
            guard let player = player else { return }
            expandableView = ExpandableView(player: player)
            expandableView?.progressView.alpha = 1
            contentView.addContentView(expandableView!)
        }
    }
    
    var index: Int? {
        didSet {
            guard let index = index else { return }
            switch index {
            case 0: expandableView?.placeLabel.text = "🥇"
            case 1: expandableView?.placeLabel.text = "🥈"
            case 2: expandableView?.placeLabel.text = "🥉"
            default: expandableView?.placeLabel.text = " "
            }
        }
    }
    
    func animateProgress() {
        guard let score = player?.score else { return }
        expandableView?.progressView.setProgress(Float(score/100), animated: true)
    }
    
    func hideExtra() {
        expandableView?.progressView.isHidden = true
        expandableView?.placeLabel.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

}
