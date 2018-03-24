//
//  UIImage.swift
//  Intuition
//
//  Created by Ruslan Maslouski on 5/23/15.
//  Copyright (c) 2015 Intuition inc. All rights reserved.
//

import UIKit

extension UIImage {
    func tintImage(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        guard let cgImage = cgImage else { return self }
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height) as CGRect
        context.clip(to: rect, mask: cgImage)
        tintColor.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
