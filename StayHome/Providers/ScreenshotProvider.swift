//
//  ShareProvider.swift
//  StayHome
//
//  Created by Enrico Castelli on 24/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit
import Photos

protocol ScreenshotProvider {
    func willTakeScreenshot()
    func didTakeScreenShot()
}

extension ScreenshotProvider {

    func takeScreenshot() -> UIImage? {
        guard let layer = UIApplication.shared.windows.first?.layer else { return nil }
        willTakeScreenshot()
        var screenshotImage :UIImage?
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        didTakeScreenShot()
        return screenshotImage
    }
}
