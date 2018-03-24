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
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var angle: Double = 0 {
        didSet {
            transform = CGAffineTransform(rotationAngle: CGFloat(angle * Double.pi / 180.0))
        }
    }

}
