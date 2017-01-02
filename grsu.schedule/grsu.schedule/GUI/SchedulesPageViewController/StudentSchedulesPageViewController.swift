//
//  StudentSchedulesPageViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/30/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class StudentSchedulesPageViewController: BaseSchedulesPageViewController {

    @IBOutlet private var favoriteBarButtonItem: UIButton!
    private var group: GroupsEntity!


    override func viewDidLoad() {
        super.viewDidLoad()

        if ( group?.favorite != nil) {
            self.favoriteBarButtonItem.selected = true
        }
    }

    func configure(group: GroupsEntity) {
        self.group = group
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Flurry.logEvent("open schedule for group", withParameters: ["group": group!.title])
    }

    @IBAction func favoriteButtonPressed(sender: UIButton) {
        sender.selected = !sender.selected

        let manager = FavoriteManager()
        if (sender.selected) {
            manager.addFavoriteWithGroup(group)
        } else {
            manager.removeFavorite(group.favorite!)
        }

        self.sidebarController?.addLeftSidebarButton(self)
    }


    override func weekScheduleController(weekIndex: Int? = nil) -> UIViewController {

        guard let possibleWeeks = possibleWeeks,
            dateScheduleQuery = dateScheduleQuery else {
                assertionFailure("possibleWeeks or dateScheduleQuery musn't be nil")
                return UIViewController()
        }

        let query = DateScheduleQuery()
        if (weekIndex != nil) {
            query.startWeekDate = possibleWeeks[weekIndex!].startDate
            query.endWeekDate = possibleWeeks[weekIndex!].endDate
        } else {
            query.startWeekDate = dateScheduleQuery.startWeekDate
            query.endWeekDate = dateScheduleQuery.endWeekDate
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("StudentWeekSchedulesViewController") as! StudentWeekSchedulesViewController
        vc.configureWithGroup(group, dateScheduleQuery: query)

        return vc
    }

    override func favoritWillRemoveNotification(notification: NSNotification) {
        let item = notification.userInfo?[GSFavoriteManagerFavoriteObjectKey] as? FavoriteEntity

        if (item?.group == group) {
            favoriteBarButtonItem.selected = false
        }
    }

}
