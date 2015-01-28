//
//  ReachabilityTableView.swift
//  grsu.schedule
//
//  Created by Ruslan on 27.01.15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

let DefaultAvailabilityHeaderHeight : CGFloat = 25

class ReachabilityTableView: UITableView {

    var unavailableHeaderLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        
        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            if (!GSReachability.sharedInstance.isHostAvailable()) {
                self.addUnavailableHeader(true)
            }
        }
        registerNotification()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func registerNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: kReachabilityChangedNotification, object: nil)
    }
    
    func reachabilityChanged(notification: NSNotification) {
        let reach = notification.object as GSReachability
        if ( !reach.isHostAvailable()) {
            addUnavailableHeader(true)
        } else {
            removeUnavailableHeader()
        }
    }
    
    func addUnavailableHeader(animated: Bool) {
        if (unavailableHeaderLabel != nil) { return }

        let headerTop : CGFloat = 64.0
        
        let headerLabel = UILabel()
        headerLabel.frame = CGRect(x: 0, y: headerTop-DefaultAvailabilityHeaderHeight, width: CGRectGetWidth(self.bounds), height: DefaultAvailabilityHeaderHeight)
        headerLabel.backgroundColor = UIColor(white: 0, alpha: 0.8)
        headerLabel.textColor = UIColor.whiteColor()
        headerLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        headerLabel.textAlignment = NSTextAlignment.Center
        headerLabel.text = "Нет связи с сетью"
        
        self.superview?.addSubview(headerLabel)
        unavailableHeaderLabel = headerLabel
        
        var inset = contentInset
        inset.top += DefaultAvailabilityHeaderHeight
        self.contentInset = inset
        self.scrollIndicatorInsets = inset
        
        let duration = animated ? 0.3 : 0
        UIView.animateWithDuration(duration, animations: { () -> Void in
            headerLabel.frame = CGRect(x: 0, y: headerTop, width: CGRectGetWidth(self.bounds), height: DefaultAvailabilityHeaderHeight)
        })
    }
    
    func removeUnavailableHeader() {
        if (unavailableHeaderLabel == nil) { return }
        
        var inset = contentInset
        inset.top -= DefaultAvailabilityHeaderHeight
        
        var newFrame = unavailableHeaderLabel?.frame
        newFrame?.origin.y += -DefaultAvailabilityHeaderHeight
        
        UIView.animateWithDuration(0.3, animations: { [weak self] () -> Void in
            if let weakSelf = self {
                weakSelf.contentInset = inset
                weakSelf.scrollIndicatorInsets = inset
                weakSelf.unavailableHeaderLabel?.frame = newFrame!
            }
        }) { [weak self] _ in
            if let weakSelf = self {
                weakSelf.unavailableHeaderLabel?.removeFromSuperview()
                weakSelf.unavailableHeaderLabel = nil
            }
        }
    }

}
