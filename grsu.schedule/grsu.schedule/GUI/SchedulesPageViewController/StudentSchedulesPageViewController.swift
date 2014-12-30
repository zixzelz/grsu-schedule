//
//  StudentSchedulesPageViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/30/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class StudentSchedulesPageViewController: BaseSchedulesPageViewController {
 
    @IBOutlet private var favoriteBarButtonItem : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ( scheduleQuery.group?.favorite != nil ) {
            self.favoriteBarButtonItem.selected = true
        }
    }
    
    override func setupPageController() {
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

    
    override func weekScheduleController(weekIndex : Int? = nil) -> UIViewController {
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

    override func favoritWillRemoveNotification(notification: NSNotification){
        let item = notification.userInfo?[GSFavoriteManagerFavoriteObjectKey] as? FavoriteEntity
        
        if (item?.group == scheduleQuery.group) {
            favoriteBarButtonItem.selected = false
        }
    }

}
