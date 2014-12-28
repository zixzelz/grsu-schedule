//
//  DefaultPresentRootViewControllerSegue.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/27/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class DefaultPresentRootViewControllerSegue: RMSidebarPresentSlideNavigationRootViewControllerSegue {
   
    override func navigationController() -> UINavigationController {
        let nc = super.navigationController()
        nc.navigationBar.barTintColor = UIColor(red: 58 / 255.0, green: 137 / 255.0, blue: 226 / 255.0, alpha: 1.0)
        nc.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        return nc
    }
    
}
