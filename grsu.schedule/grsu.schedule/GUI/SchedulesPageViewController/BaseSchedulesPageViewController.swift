//
//  SchedulesPageViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class BaseSchedulesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBInspectable var backgroundColor : UIColor = UIColor.whiteColor()
    
    @IBOutlet private var navigationTitle : UILabel!
    @IBOutlet private var pageControl : UIPageControl!
    
    var possibleWeeks : Array<GSWeekItem>!
    var scheduleQuery : BaseScheduleQuery!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
        self.delegate = self
    }

    override func viewDidLoad() {
        
        self.view.backgroundColor = backgroundColor
        setupPageController()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "favoritWillRemoveNotification:", name: GSFavoriteManagerFavoritWillRemoveNotificationKey, object: nil)
    }
    
    func setupPageController() {
        let weeks = possibleWeeks.map { $0.startDate } as [NSDate]!

        pageControl.numberOfPages = possibleWeeks.count
        pageControl.currentPage = find(weeks, scheduleQuery.startWeekDate!)!
        updateNavigationTitle()
        
        let vc = weekScheduleController()
        self.setViewControllers([vc], direction: .Forward, animated: false, completion: nil)
    }
    
    func updateNavigationTitle() {
        let index = pageControl.currentPage

        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.navigationTitle.alpha = 0.0
            self.navigationTitle.text = self.possibleWeeks[index].value
            self.navigationTitle.alpha = 1.0
        })
    }
    
    func weekScheduleController(weekIndex : Int? = nil) -> UIViewController {
        let vc = UIViewController()
        return vc
    }

    func favoritWillRemoveNotification(notification: NSNotification){
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var vc : UIViewController?
        if (pageControl.currentPage > 0) {
            let index = pageControl.currentPage - 1
            vc = weekScheduleController(weekIndex: index)
        }
        return vc
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var vc : UIViewController?
        if (pageControl.currentPage < pageControl.numberOfPages - 1) {
            let index = pageControl.currentPage + 1
            vc = weekScheduleController(weekIndex: index)
        }
        return vc
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if (completed) {
            if let vc = pageViewController.viewControllers.last as? WeekSchedulesViewController {
                let index = indexOfViewController(vc)
                pageControl.currentPage = index
                updateNavigationTitle()
            }
        }
    }

    // MARK: - Utils

    func indexOfViewController(vc: WeekSchedulesViewController) -> Int {
        let weeks = possibleWeeks.map { $0.startDate } as [NSDate]!
        return find(weeks, vc.scheduleQuery!.startWeekDate!)!
    }
    
}
