//
//  RoundImageView.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/17/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

@IBDesignable
class RoundImageView: UIImageView {

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

    @IBInspectable var angle: Double = 0{
        didSet {
            self.transform = CGAffineTransformMakeRotation(CGFloat((angle) * M_PI / 180.0));
        }
    }

}
