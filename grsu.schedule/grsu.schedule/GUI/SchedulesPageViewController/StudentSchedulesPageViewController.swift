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
    var group : GroupsEntity?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ( group?.favorite != nil ) {
            self.favoriteBarButtonItem.selected = true
        }
    }

    
    @IBAction func favoriteButtonPressed(sender: UIButton) {
        sender.selected = !sender.selected
        
        let manager = FavoriteManager()
        if (sender.selected) {
            manager.addFavorite(group!)
        } else {
            manager.removeFavorite(group!.favorite)
        }
        
        self.sidebarController?.addLeftSidebarButton(self)
    }

    
    override func weekScheduleController(weekIndex : Int? = nil) -> UIViewController {
        let query = DateScheduleQuery()
        if (weekIndex != nil) {
            query.startWeekDate = possibleWeeks[weekIndex!].startDate
            query.endWeekDate = possibleWeeks[weekIndex!].endDate
        } else {
            query.startWeekDate = dateScheduleQuery.startWeekDate
            query.endWeekDate = dateScheduleQuery.endWeekDate
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("StudentWeekSchedulesViewController") as StudentWeekSchedulesViewController
        vc.dateScheduleQuery = query
        vc.group = group
        
        return vc
    }

    override func favoritWillRemoveNotification(notification: NSNotification) {
        let item = notification.userInfo?[GSFavoriteManagerFavoriteObjectKey] as? FavoriteEntity
        
        if (item?.group == group) {
            favoriteBarButtonItem.selected = false
        }
    }

}
