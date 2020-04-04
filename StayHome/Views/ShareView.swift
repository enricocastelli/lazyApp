//
//  ShareView.swift
//  StayHome
//
//  Created by Enrico Castelli on 24/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit
import Photos


class ShareView: UIView {
   
    var stack = UIStackView()
    let image: UIImage
    let spacing: CGFloat = 16

    init(_ image: UIImage, startingFrame: CGRect) {
        self.image = image
        var adjustedFrame = startingFrame
        adjustedFrame.origin.y += startingFrame.height + spacing
        adjustedFrame.size = CGSize(width: startingFrame.height, height: (startingFrame.height*2) + spacing)
        super.init(frame: adjustedFrame)
        addStack()
        addOptions()
        transform = CGAffineTransform(translationX: 200, y: 0)
        backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        UIView.animate(withDuration: 0.4) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    func close() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(translationX: 200, y: 0)
        }) { (_) in
            self.removeFromSuperview()
        }
    }

    private func addStack() {
        addContentView(stack)
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = spacing
    }

    private func addOptions() {
        let igBtn = UIButton()
        igBtn.setAspectRatio(1, 1)
        igBtn.setBackgroundImage(UIImage.instagram, for: .normal)
        stack.addArrangedSubview(igBtn)
        igBtn.addTarget(self, action: #selector(igTapped), for: .touchUpInside)
        let btn = UIButton()
        btn.tintColor = .black
        btn.setBackgroundImage(UIImage(systemName: "paperclip"), for: .normal)
        btn.setAspectRatio(1, 1)
        stack.addArrangedSubview(btn)
        btn.addTarget(self, action: #selector(generalTapped), for: .touchUpInside)
    }

    @objc func igTapped() {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        guard let lastAsset = fetchResult.firstObject, let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)"), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func generalTapped() {
        guard let nav = UIApplication.shared.windows.first?.rootViewController as? Navigation else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        nav.present(activityViewController, animated: true, completion: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
