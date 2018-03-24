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

    @IBOutlet fileprivate var favoriteBarButtonItem: UIButton!
    fileprivate var group: GroupsEntity!

    override func viewDidLoad() {
        super.viewDidLoad()

        if (group?.favorite != nil) {
            favoriteBarButtonItem.isSelected = true
        }
    }

    func configure(_ group: GroupsEntity) {
        self.group = group
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Flurry.logEvent("open schedule for group", withParameters: ["group": group!.title])
    }

    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        let manager = FavoriteManager()
        if sender.isSelected {
            manager.addFavoriteWithGroup(group)
        } else {
            manager.removeFavorite(group.favorite!)
        }
    }


    override func weekScheduleController(_ weekIndex: Int? = nil) -> UIViewController {

        guard let possibleWeeks = possibleWeeks,
            let dateScheduleQuery = dateScheduleQuery else {
                assertionFailure("possibleWeeks or dateScheduleQuery musn't be nil")
                return UIViewController()
        }

        let query = DateScheduleQuery()
        if weekIndex != nil {
            query.startWeekDate = possibleWeeks[weekIndex!].startDate
            query.endWeekDate = possibleWeeks[weekIndex!].endDate
        } else {
            query.startWeekDate = dateScheduleQuery.startWeekDate
            query.endWeekDate = dateScheduleQuery.endWeekDate
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StudentWeekSchedulesViewController") as! StudentWeekSchedulesViewController
        vc.configureWithGroup(group, dateScheduleQuery: query)

        return vc
    }

    override func favoritWillRemoveNotification(_ notification: Foundation.Notification) {
        let item = notification.userInfo?[GSFavoriteManagerFavoriteObjectKey] as? FavoriteEntity

        if item?.group == group {
            favoriteBarButtonItem.isSelected = false
        }
    }

}
