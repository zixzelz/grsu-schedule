//
//  RoundBorderButton.swift
//  Intuition
//
//  Created by Ruslan Maslouski on 3/28/15.
//  Copyright (c) 2015 Intuition inc. All rights reserved.
//

import UIKit

@IBDesignable
class RoundBorderButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var angle: Double = 0 {
        didSet {
            self.transform = CGAffineTransformMakeRotation(CGFloat((angle) * M_PI / 180.0));
        }
    }

}
