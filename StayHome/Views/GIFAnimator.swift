//
//  GIFAnimator.swift
//  StayHome
//
//  Created by Enrico Castelli on 03/04/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

open class Animator: UIImageView {
    
    private var images: [UIImage]
    private var frameTime: Double
    private var timer = Timer()
    private var imageCount = 0
    private var shouldStop = false
    private var completionStop: ()->()? = {}
    
    
    public init(_ frame: CGRect, imageName: String, count: Int, frameTime: Double) {
        self.images = getImages(imageName, count)
        self.frameTime = frameTime
        super.init(frame: frame)
        setup()
    }
    
    func setup() {} // overriden
    
    private func timerCall() {
        if imageCount >= images.count {
            imageCount = 0
        }
        self.image = images[imageCount]
        if imageCount == 0 && shouldStop {
            timer.invalidate()
            completionStop()
        }
        imageCount += 1
    }
    
    open func start(_ frameTime: Double? = nil) {
        shouldStop = false
        timer = Timer.scheduledTimer(withTimeInterval: frameTime ?? self.frameTime, repeats: true, block: { (timer) in
            self.timerCall()
        })
        timer.fire()
    }
    
    open func stop() {
        timer.invalidate()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

fileprivate func getImages(_ imageName: String,_ count: Int) -> [UIImage] {
    var arr = [UIImage]()
    for ind in 1...count {
        if let img = UIImage(named: "\(imageName)\(ind)") {
            arr.append(img)
        }
    }
    return arr
}
