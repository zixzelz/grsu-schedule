//
//  SchedulesPageViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class SchedulesPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var scheduleQuery : StudentScheduleQuery?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
        
        let vc = weekScheduleController()
        self.setViewControllers([vc], direction: .Forward, animated: false, completion: nil)
    }

    func weekScheduleController(query : StudentScheduleQuery? = nil) -> WeekSchedulesViewController {
        let q = query ?? scheduleQuery
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("WeekSchedulesViewController") as WeekSchedulesViewController
        vc.scheduleQuery = q
        
        return vc
    }
    
    // pragma mark - UIPageViewControllerDataSource

    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    
    // pragma mark - UIPageViewControllerDelegate


}
