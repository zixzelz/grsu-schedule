//
//  ViewController+SidebarController.swift
//  SubPage
//
//  Created by Ruslan Maslouski on 9/23/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

extension UIViewController {

    var sidebarController: RMSidebarController? { get {
        var parent = self.parentViewController
        
        var c1 : NSObject? = parent
        let c2 = self.navigationController
        let c3 : NSObject? = NSObject()
        
        let res = (parent is RMSidebarController ? parent : nil) ??
            (self.navigationController != nil ? self.navigationController?.sidebarController : nil) ??
            (self.presentingViewController? is RMSidebarController ? self.presentingViewController : nil);
        return res as RMSidebarController?
        }
    }
}
