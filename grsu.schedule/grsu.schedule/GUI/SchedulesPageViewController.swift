//
//  SchedulesPageViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class SchedulesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBInspectable var backgroundColor : UIColor = UIColor.whiteColor()
    
    @IBOutlet private var navigationTitle : UILabel!
    @IBOutlet private var pageControl : UIPageControl!
    @IBOutlet private var favoriteBarButtonItem : UIButton!
    
    var scheduleQuery : StudentScheduleQuery!
    var possibleWeeks : Array<GSWeekItem>!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
        self.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ( scheduleQuery.group?.favorite != nil ) {
            self.favoriteBarButtonItem.selected = true
        }
        
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
    
    @IBAction func favoriteButtonPressed(sender: UIButton) {
        sender.selected = !sender.selected
        
        let manager = FavoriteManager()
        if (sender.selected) {
            manager.addFavorite(scheduleQuery.group!)
        } else {
            manager.removeFavorite(scheduleQuery.group!.favorite)
        }
        
        self.sidebarController?.addLeftSidebarButton(self)
    }
    
    func updateNavigationTitle() {
        let index = pageControl.currentPage

        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.navigationTitle.alpha = 0.0
            self.navigationTitle.text = self.possibleWeeks[index].value
            self.navigationTitle.alpha = 1.0
        })
    }
    
    func weekScheduleController(weekIndex : Int? = nil) -> WeekSchedulesViewController {
        let query = StudentScheduleQuery(q: scheduleQuery)
        if (weekIndex != nil) {
            query.startWeekDate = possibleWeeks[weekIndex!].startDate
            query.endWeekDate = possibleWeeks[weekIndex!].endDate
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("WeekSchedulesViewController") as WeekSchedulesViewController
        vc.scheduleQuery = query
        
        return vc
    }

    func favoritWillRemoveNotification(notification: NSNotification){
        let item = notification.userInfo?[GSFavoriteManagerFavoriteObjectKey] as? FavoriteEntity
        
        if (item?.group == scheduleQuery.group) {
            favoriteBarButtonItem.selected = false
        }
        
        //Action take on Notification
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var vc : UIViewController?
        if (pageControl.currentPage > 0) {
            let index = pageControl.currentPage - 1
//            let week = possibleWeeks[index]
            
            vc = weekScheduleController(weekIndex: index)
        }
        return vc
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var vc : UIViewController?
        if (pageControl.currentPage < pageControl.numberOfPages - 1) {
            let index = pageControl.currentPage + 1
//            let week = possibleWeeks[index]
            
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
