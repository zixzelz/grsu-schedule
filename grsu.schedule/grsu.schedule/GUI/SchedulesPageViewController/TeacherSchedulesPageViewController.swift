//
//  TeacherSchedulesPageViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

class TeacherSchedulesPageViewController: BaseSchedulesPageViewController {

    @IBOutlet private var favoriteBarButtonItem : UIButton!
    var teacher : TeacherInfoEntity?    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ( teacher?.favorite != nil ) {
            self.favoriteBarButtonItem.selected = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Flurry.logEvent("open schedule for teacher", withParameters: ["teacher": teacher!.title!])
    }
    
    @IBAction func favoriteButtonPressed(sender: UIButton) {
        sender.selected = !sender.selected
        
        let manager = FavoriteManager()
        if (sender.selected) {
            manager.addFavorite(teacher!)
        } else {
            manager.removeFavorite(teacher!.favorite!)
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
        let vc = storyboard.instantiateViewControllerWithIdentifier("TeacherWeekSchedulesViewController") as! TeacherWeekSchedulesViewController
        vc.dateScheduleQuery = query
        vc.teacher = teacher
        
        return vc
    }
    
    override func favoritWillRemoveNotification(notification: NSNotification) {
        let item = notification.userInfo?[GSFavoriteManagerFavoriteObjectKey] as? FavoriteEntity
        
        if (item?.teacher == teacher) {
            favoriteBarButtonItem.selected = false
        }
    }
    
}
