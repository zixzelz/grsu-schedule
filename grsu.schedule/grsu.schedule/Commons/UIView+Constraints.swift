//
//  UIView+Constraints.swift
//  BuddyHOPP
//
//  Created by Ruslan Maslouski on 6/15/19.
//  Copyright © 2019 Buddyhopp Inc. All rights reserved.
//

import UIKit

public extension UIView {

    func addStretchingConstraints(inset: UIEdgeInsets = UIEdgeInsets.zero) {
        if let superview = superview {
            translatesAutoresizingMaskIntoConstraints = false
            let views = ["view": self]
            superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(inset.left)-[view]-\(inset.right)-|", options: [], metrics: nil, views: views))
            superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(inset.top)-[view]-\(inset.bottom)-|", options: [], metrics: nil, views: views))
        }
    }

    func addSubviewWithStretchingConstraints(_ view: UIView, inset: UIEdgeInsets = UIEdgeInsets.zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.addStretchingConstraints(inset: inset)
    }

    func addSubviewInCenter(_ view: UIView, with size: CGSize? = nil) {
        addSubview(view)
        if let size = size {
            view.addSizeConstraints(size)
        }
        view.addInCenterConstraints()
    }

    func addInCenterConstraints() {
        if let superview = superview {
            translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        }
    }

    func addSizeConstraints(_ size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
