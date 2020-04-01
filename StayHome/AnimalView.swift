//
//  AnimalVC.swift
//  StayHome
//
//  Created by Enrico Castelli on 23/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

protocol AnimalViewDelegate {
    func didOpen()
    func didClose()
    func willTakeScreenshot()
    func didTakeScreenShot()
}

class AnimalView: NibView, ScreenshotProvider {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    
    let animal: LazyAnimal
    var delegate: AnimalViewDelegate?
    var expanded = false
    var originalCenter: CGPoint = .zero
    var shareView: ShareView?
    var shareIsOpen = false
    
    init(_ animal: LazyAnimal) {
        self.animal = animal
        super.init(frame: .zero)
    }
    
    override func nibSetup() {
        super.nibSetup()
        imageView.image = animal.image
        label.text = animal.name
        textView.text = animal.description
        layer.cornerRadius = 8
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        clipsToBounds = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        shareButton.alpha = 0
        shareButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 1) {
            self.shareButton.alpha = 0.6
        }
    }
    
    @objc func viewTapped() {
        closeShareView()
        guard !expanded else { return }
        expanded = true
        delegate?.didOpen()
        let screenEdge = UIPanGestureRecognizer(target: self, action: #selector(swiped(_:)))
        view.addGestureRecognizer(screenEdge)
        centerConstraint.priority = .high
        heightConstraint.priority = .low
        UIView.animate(withDuration: 0.3) {
            self.label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.shareButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.originalCenter = self.center
            self.center.y = UIScreen.main.bounds.height/2
            self.layer.borderWidth = 0.1
            self.layoutIfNeeded()
        }
    }
    
    func dismiss() {
        closeShareView()
        delegate?.didClose()
        expanded = false
        centerConstraint.priority = .low
        heightConstraint.priority = .high
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.label.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.shareButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.center = self.originalCenter
            self.layer.borderWidth = 2
        }
    }
        
    @objc func swiped(_ swipe: UIPanGestureRecognizer) {
        guard (swipe.velocity(in: view).y > 0) else { return }
        switch swipe.state {
        case .ended:
            dismiss()
        default: break
        }
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        shareIsOpen ? closeShareView() : openShareView()
        shareIsOpen = !shareIsOpen
    }
    
    private func openShareView() {
        guard let image = takeScreenshot() else { return }
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up.fill"), for: .normal)
        let size = shareButton.frame
        shareView = ShareView(image, startingFrame: size)
        view.addSubview(shareView!)
    }
    
    
    private func closeShareView() {
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareView?.close()
    }
    
    func willTakeScreenshot() {
        shareButton.isHidden = true
        delegate?.willTakeScreenshot()
    }
    
    func didTakeScreenShot() {
        shareButton.isHidden = false
        delegate?.didTakeScreenShot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
