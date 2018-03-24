//
//  MySchedulesPageViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/2/17.
//  Copyright © 2017 Ruslan Maslouski. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class MySchedulesPageViewController: BaseSchedulesPageViewController {

    fileprivate var studentId: String!

    override func viewDidLoad() {
        configure()
        super.viewDidLoad()
    }

    fileprivate func configure() {

        if let student = UserDefaults.student {

            let weeks = DateManager.scheduleWeeks()
            let studentId = student.id
            let scheduleQuery = DateScheduleQuery()
            scheduleQuery.startWeekDate = weeks.first!.startDate
            scheduleQuery.endWeekDate = weeks.first!.endDate

            dateScheduleQuery = scheduleQuery
            possibleWeeks = weeks
            configure("\(studentId)")
        }
    }

    func configure(_ studentId: String) {
        self.studentId = studentId
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Flurry.logEvent("open My schedule", withParameters: ["studentId": studentId ?? "nil"])
    }

    override func weekScheduleController(_ weekIndex: Int? = nil) -> UIViewController {

        guard let possibleWeeks = possibleWeeks,
            let dateScheduleQuery = dateScheduleQuery else {
                assertionFailure("possibleWeeks or dateScheduleQuery musn't be nil")
                return UIViewController()
        }

        let query = DateScheduleQuery()
        if let weekIndex = weekIndex {
            query.startWeekDate = possibleWeeks[weekIndex].startDate
            query.endWeekDate = possibleWeeks[weekIndex].endDate
        } else {
            query.startWeekDate = dateScheduleQuery.startWeekDate
            query.endWeekDate = dateScheduleQuery.endWeekDate
        }

        let storyboard = UIStoryboard.mainStoryboard()
        let vc = storyboard.instantiateViewController(withIdentifier: "StudentWeekSchedulesViewController") as! StudentWeekSchedulesViewController
        vc.configureWithStudent(studentId, dateScheduleQuery: query)

        return vc
    }
}
