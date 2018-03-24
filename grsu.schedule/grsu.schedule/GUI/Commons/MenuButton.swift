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

    fileprivate var editing: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    fileprivate func setupView() {

        imageView?.contentMode = .scaleToFill
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.textAlignment = .center
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false

        let dict = ["imageView": imageView!, "titleLabel": titleLabel!]

        removeConstraints(constraints)

        editing = true
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: imageView, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[imageView]", options: .alignAllLeft, metrics: nil, views: dict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|", options: .alignAllLeft, metrics: nil, views: dict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLabel(12)]-4-|", options: .alignAllLeft, metrics: nil, views: dict))
        editing = false
    }

    override func addConstraints(_ constraints: [NSLayoutConstraint]) {
        if editing {
            super.addConstraints(constraints)
        }
    }

    override func addConstraint(_ constraint: NSLayoutConstraint) {
        if editing {
            super.addConstraint(constraint)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.imageView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) 
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) 
    }
    
}
