//
//  CustomSegue.swift
//  SubPage
//
//  Created by Ruslan Maslouski on 9/11/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class RMSidebarInitRootViewControllerSegue: UIStoryboardSegue {
    override func perform() {
        if let src = self.sourceViewController as? RMSidebarController {

            let dest = self.destinationViewController as UIViewController
            src.presentRootViewController(dest, animated: false)
        }
    }

}
