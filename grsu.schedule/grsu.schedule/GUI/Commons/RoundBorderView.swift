//
//  RoundBorderView.swift
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
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var angle: Double = 0 {
        didSet {
            self.transform = CGAffineTransform(rotationAngle: CGFloat(angle * Double.pi / 180.0));
        }
    }
}
