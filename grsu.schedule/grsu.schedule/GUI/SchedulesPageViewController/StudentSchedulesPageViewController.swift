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
    private var studentScheduleQuery : StudentScheduleQuery { get { return self.scheduleQuery as StudentScheduleQuery } }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ( studentScheduleQuery.group?.favorite != nil ) {
            self.favoriteBarButtonItem.selected = true
        }
    }

    
    @IBAction func favoriteButtonPressed(sender: UIButton) {
        sender.selected = !sender.selected
        
        let manager = FavoriteManager()
        if (sender.selected) {
            manager.addFavorite(studentScheduleQuery.group!)
        } else {
            manager.removeFavorite(studentScheduleQuery.group!.favorite)
        }
        
        self.sidebarController?.addLeftSidebarButton(self)
    }

    
    override func weekScheduleController(weekIndex : Int? = nil) -> UIViewController {
        let query = StudentScheduleQuery(studentQuery: studentScheduleQuery)
        if (weekIndex != nil) {
            query.startWeekDate = possibleWeeks[weekIndex!].startDate
            query.endWeekDate = possibleWeeks[weekIndex!].endDate
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("WeekSchedulesViewController") as WeekSchedulesViewController
        vc.scheduleQuery = query
        
        return vc
    }

    override func favoritWillRemoveNotification(notification: NSNotification) {
        let item = notification.userInfo?[GSFavoriteManagerFavoriteObjectKey] as? FavoriteEntity
        
        if (item?.group == studentScheduleQuery.group) {
            favoriteBarButtonItem.selected = false
        }
    }

}
