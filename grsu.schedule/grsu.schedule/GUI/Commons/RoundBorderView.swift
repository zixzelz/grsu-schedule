//
//  RoundBorderView.swift
//  HelpBook
//
//  Created by Ruslan Maslouski on 3/24/15.
//  Copyright (c) 2015 Intuition Inc. All rights reserved.
//

import UIKit

@IBDesignable
class RoundBorderView: UIView {

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
