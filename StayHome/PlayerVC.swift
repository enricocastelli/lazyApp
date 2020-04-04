//
//  PlayerVC.swift
//  StayHome
//
//  Created by Enrico Castelli on 25/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

protocol PlayerVCDelegate {
    func shouldUpdate()
}

protocol DetailPresentable where Self: UIViewController {
    func animateOpening()
    func animateClosing()
}

class PlayerVC: UIViewController, DetailPresentable, FirestoreProvider, AlertProvider {
    
    @IBOutlet weak var barView: BarView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    let expandableView: ExpandableView
    let player: Player
    var delegate: PlayerVCDelegate?
    
    init(_ player: Player) {
        self.player = player
        self.expandableView = ExpandableView(player: player)
        super.init(nibName: String(describing: PlayerVC.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barView.alpha = 0
        containerView.addContentView(expandableView)
        setBarView()
        removeButton.layer.cornerRadius = 8
        challengeButton.layer.cornerRadius = 8
        //challengeButton.isHidden = true
        if let friends = player.friends {
            label.text = "\(friends.count) Friends"
        }
    }
    
    private func setBarView() {
        barView.onLeftTap = backTapped
        barView.rightImage = nil
    }

    func animateOpening() {
        barView.alpha = 1
        removeButton.isHidden = false
        challengeButton.alpha = 1
        label.alpha = 1
        expandableView.animateOpening()
        topConstraint.constant = expandableView.subtitleLabel.frame.maxY + 36
    }
    
    func animateClosing() {
        barView.alpha = 0
        removeButton.isHidden = true
        challengeButton.alpha = 0
        label.alpha = 0
        topConstraint.constant = 0
        expandableView.animateClosing()
    }
    
    private func backTapped() {
        navigation.closeDetail()
    }
    
    @IBAction func challengeTapped(_ sender: Any) {
        self.present(ChallengeVC(player), animated: true, completion: nil)
    }
    
    @IBAction func removeTapped(_ sender: UIButton) {
        removeFriend(player.id, success: {
            self.delegate?.shouldUpdate()
            self.navigation.closeDetail()
        }) { (error) in
            self.presentGeneralError(error)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
