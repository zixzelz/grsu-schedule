//
//  SidebarPresentRootViewControllerSegue.swift
//  SubPage
//
//  Created by Ruslan Maslouski on 9/24/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class RMSidebarPresentSlideRootViewControllerSegue: UIStoryboardSegue {

    override func perform() {
        let src  = self.sourceViewController as UIViewController
        let sidebar = src.sidebarController
        let dest = self.destinationViewController as UIViewController
        if (sidebar != nil) {
            sidebar!.presentRootViewController(dest, animated: true)
        }
    }
}
