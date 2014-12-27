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
        nc.navigationBar.tintColor = UIColor(red: 72 / 255.0, green: 157 / 255.0, blue: 232 / 255.0, alpha: 1.0)
        nc.navigationBar.tintColor = UIColor.whiteColor()
        
        return nc
    }
    
}
