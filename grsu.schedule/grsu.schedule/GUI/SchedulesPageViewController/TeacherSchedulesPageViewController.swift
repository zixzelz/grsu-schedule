//
//  TeacherSchedulesPageViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class TeacherSchedulesPageViewController: BaseSchedulesPageViewController {

    @IBOutlet fileprivate var favoriteBarButtonItem: UIButton!
    var teacher: TeacherInfoEntity?

    override func viewDidLoad() {
        super.viewDidLoad()

        if (teacher?.favorite != nil) {
            self.favoriteBarButtonItem.isSelected = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let title = teacher?.displayTitle {
            Flurry.logEvent("open schedule for teacher", withParameters: ["teacher": title])
        }
    }

    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        let manager = FavoriteManager()
        if sender.isSelected {
            manager.addFavorite(teacher!)
        } else {
            manager.removeFavorite(teacher!.favorite!)
        }
    }

    override func weekScheduleController(_ weekIndex: Int? = nil) -> UIViewController {
        
        guard let possibleWeeks = possibleWeeks,
            let dateScheduleQuery = dateScheduleQuery else {
                assertionFailure("possibleWeeks or dateScheduleQuery musn't be nil")
                return UIViewController()
        }

        let query = DateScheduleQuery()
        if let index = weekIndex {
            query.startWeekDate = possibleWeeks[index].startDate
            query.endWeekDate = possibleWeeks[index].endDate
        } else {
            query.startWeekDate = dateScheduleQuery.startWeekDate
            query.endWeekDate = dateScheduleQuery.endWeekDate
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TeacherWeekSchedulesViewController") as! TeacherWeekSchedulesViewController
        vc.dateScheduleQuery = query
        vc.teacher = teacher

        return vc
    }

    override func favoritWillRemoveNotification(_ notification: Foundation.Notification) {
        let item = notification.userInfo?[GSFavoriteManagerFavoriteObjectKey] as? FavoriteEntity

        if (item?.teacher == teacher) {
            favoriteBarButtonItem.isSelected = false
        }
    }

}

extension TeacherSchedulesPageViewController: SecondarySplitViewControllerProtocol {
    func shouldCollapsed() -> Bool {
        return teacher == nil
    }
}
