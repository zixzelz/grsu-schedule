//
//  UIImage.swift
//  Intuition
//
//  Created by Ruslan Maslouski on 5/23/15.
//  Copyright (c) 2015 Intuition inc. All rights reserved.
//

import UIKit

extension UIImage {
    func tintImage(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        guard let cgImage = CGImage else { return self }
        
        let context = UIGraphicsGetCurrentContext()!
        CGContextTranslateCTM(context, 0, size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, size.width, size.height) as CGRect
        CGContextClipToMask(context, rect, cgImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
