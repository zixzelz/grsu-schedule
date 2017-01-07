//
//  MenuButton.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/7/17.
//  Copyright © 2017 Ruslan Maslouski. All rights reserved.
//

import UIKit

@IBDesignable
class MenuButton: UIButton {

    private var editing: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {

        imageView?.contentMode = .Center
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.textAlignment = .Center
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false

        let dict = ["imageView": imageView!, "titleLabel": titleLabel!]

        removeConstraints(constraints)

        editing = true
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: .AlignAllLeft, metrics: nil, views: dict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[titleLabel]|", options: .AlignAllLeft, metrics: nil, views: dict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-3-[imageView][titleLabel(12)]-4-|", options: .AlignAllLeft, metrics: nil, views: dict))
        editing = false
    }

    override func addConstraints(constraints: [NSLayoutConstraint]) {
        if editing {
            super.addConstraints(constraints)
        }
    }

    override func addConstraint(constraint: NSLayoutConstraint) {
        if editing {
            super.addConstraint(constraint)
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        UIView.animateWithDuration(0.1) {
            self.imageView?.transform = CGAffineTransformMakeScale(0.8, 0.8)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        UIView.animateWithDuration(0.1) {
            self.imageView?.transform = CGAffineTransformMakeScale(1, 1)
        }
    }
    
}
