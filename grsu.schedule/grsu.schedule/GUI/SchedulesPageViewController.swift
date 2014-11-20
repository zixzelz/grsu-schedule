//
//  SchedulesPageViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class SchedulesPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
        
        self.reloadInputViews()
    }

    
    // pragma mark - UIPageViewControllerDataSource

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 1;
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    
    // pragma mark - UIPageViewControllerDelegate


}
