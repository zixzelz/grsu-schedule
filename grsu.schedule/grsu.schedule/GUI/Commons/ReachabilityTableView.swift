//
//  ReachabilityTableView.swift
//  grsu.schedule
//
//  Created by Ruslan on 27.01.15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

let DefaultAvailabilityHeaderHeight: CGFloat = 25

class ReachabilityTableView: UITableView {

    var unavailableHeaderLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()


        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { () -> Void in
            if (!GSReachability.sharedInstance.isHostAvailable()) {
                self.addUnavailableHeader(true)
            }
        }
        registerNotification()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(ReachabilityTableView.reachabilityChanged(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
    }

    @objc func reachabilityChanged(_ notification: Foundation.Notification) {
        let reach = notification.object as! GSReachability
        if (!reach.isHostAvailable()) {
            addUnavailableHeader(true)
        } else {
            removeUnavailableHeader()
        }
    }

    func addUnavailableHeader(_ animated: Bool) {
        if (unavailableHeaderLabel != nil) { return }

        let headerTop: CGFloat = 0

        let headerLabel = UILabel()
        headerLabel.frame = CGRect(x: 0, y: headerTop - DefaultAvailabilityHeaderHeight, width: self.bounds.width, height: DefaultAvailabilityHeaderHeight)
        headerLabel.backgroundColor = UIColor(white: 0, alpha: 0.8)
        headerLabel.textColor = UIColor.white
        headerLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        headerLabel.textAlignment = NSTextAlignment.center
        headerLabel.text = "Нет связи с сетью"

        self.superview?.addSubview(headerLabel)
        unavailableHeaderLabel = headerLabel

        var inset = contentInset
        inset.top += DefaultAvailabilityHeaderHeight
        self.contentInset = inset
        self.scrollIndicatorInsets = inset

        let duration = animated ? 0.3 : 0
        UIView.animate(withDuration: duration, animations: { () -> Void in
            headerLabel.frame = CGRect(x: 0, y: headerTop, width: self.bounds.width, height: DefaultAvailabilityHeaderHeight)
        })
    }

    func removeUnavailableHeader() {
        if (unavailableHeaderLabel == nil) { return }

        var inset = contentInset
        inset.top -= DefaultAvailabilityHeaderHeight

        var newFrame = unavailableHeaderLabel?.frame
        newFrame?.origin.y += -DefaultAvailabilityHeaderHeight

        UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.contentInset = inset
                strongSelf.scrollIndicatorInsets = inset
                strongSelf.unavailableHeaderLabel?.frame = newFrame!
            }
        }, completion: { [weak self] _ in
                if let strongSelf = self {
                    strongSelf.unavailableHeaderLabel?.removeFromSuperview()
                    strongSelf.unavailableHeaderLabel = nil
                }
            })
    }

}
