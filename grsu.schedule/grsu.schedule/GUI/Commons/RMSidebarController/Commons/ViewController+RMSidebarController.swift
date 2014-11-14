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
        
        return nil;
        
//        return (parent? is RMSidebarController ? parent : nil) ??
//            (self.navigationController ? self.navigationController?.sidebarController : nil) ??
//            (self.presentingViewController? is RMSidebarController ? self.presentingViewController : nil);
        }
    }
}