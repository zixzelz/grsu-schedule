//
//  ReachabilityTableView.swift
//  grsu.schedule
//
//  Created by Ruslan on 27.01.15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

class ReachabilityTableView: UITableView {

    override func awakeFromNib() {
        super.awakeFromNib();
        
        if (!GSReachability.sharedInstance.isHostAvailable()) {
            addUnavailableHeader()
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
            addUnavailableHeader()
        } else {
            removeUnavailableHeader()
        }
    }
    
    func addUnavailableHeader() {
        let headerLabel = UILabel()
        headerLabel.backgroundColor = UIColor(white: 0, alpha: 0.8)
        headerLabel.textColor = UIColor.whiteColor()
        headerLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        headerLabel.textAlignment = NSTextAlignment.Center
        headerLabel.text = "Нет связи с сетью"
        
        tableHeaderView = headerLabel
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            headerLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 25)
        })
    }
    
    func removeUnavailableHeader() {
        UIView.animateWithDuration(0.3, animations: { [weak self] () -> Void in
            if let weakSelf = self {
                weakSelf.tableHeaderView?.frame = CGRectZero
            }
        }) { [weak self] _ in
            if let weakSelf = self {
                weakSelf.tableHeaderView = nil
            }
        }
    }

}
