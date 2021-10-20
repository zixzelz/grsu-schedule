//
//  StudentWeekSchedulesViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class StudentWeekSchedulesViewController: WeekSchedulesViewController {

    fileprivate var group: GroupsEntity?
    fileprivate var studentId: String?

    func configureWithStudent(_ studentId: String, dateScheduleQuery: DateScheduleQuery) {
        self.studentId = studentId
        self.dateScheduleQuery = dateScheduleQuery
    }

    func configureWithGroup(_ group: GroupsEntity, dateScheduleQuery: DateScheduleQuery) {
        self.group = group
        self.dateScheduleQuery = dateScheduleQuery
    }

    override func fetchData(_ useCache: Bool = true, animated: Bool) {
        super.fetchData(useCache, animated: animated)

        guard let startWeekDate = dateScheduleQuery?.startWeekDate, let endWeekDate = dateScheduleQuery?.endWeekDate else {
            assertionFailure("Miss param query:\(self.dateScheduleQuery)")
            return
        }

        let cache: CachePolicy = useCache ? .cachedElseLoad : .reloadIgnoringCache
        fetchDataWithStudentId(startWeekDate, dateEnd: endWeekDate, cache: cache) { [weak self] result -> Void in

            guard let strongSelf = self else { return }

            switch result {
            case .success(let items):
                strongSelf.setLessonSchedule(items)
            case .failure(let error):

                Flurry.logError(error, errId: "StudentWeekSchedulesViewController")
                strongSelf.showMessage(L10n.loadingFailedMessage)
            }
            strongSelf.reloadData(animated)
        }
    }

    fileprivate func fetchDataWithStudentId(_ dateStart: Date, dateEnd: Date, cache: CachePolicy, completionHandler: @escaping StudentScheduleCompletionHandlet) {

        if let group = group {
            ScheduleService().getStudentSchedule(group, dateStart: dateStart, dateEnd: dateEnd, cache: cache, completionHandler: completionHandler)
        } else if let studentId = studentId {
            ScheduleService().getMySchedule(studentId, dateStart: dateStart, dateEnd: dateEnd, cache: cache, completionHandler: completionHandler)
        } else {
            assertionFailure("Miss params group and studentId")
        }
    }

    override func configure(_ cell: LessonScheduleCell, lesson: LessonScheduleEntity) {
        cell.configureStuden(lesson)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let schedules = schedules, let menuCellIndexPath = menuCellIndexPath else {
            assertionFailure("schedules or menuCellIndexPath is empty")
            return
        }

        if (segue.identifier == "TeacherInfoIdentifier") {

            let lesson = schedules[menuCellIndexPath.section].lessons[menuCellIndexPath.row - 1] as LessonScheduleEntity

            let navigationController = segue.destination as? UINavigationController
            let viewController = navigationController?.viewControllers.first as? TeacherInfoViewController
            viewController?.teacherInfo = lesson.teacher

        } else if (segue.identifier == "TeacherSchedulePageIdentifier") {

            let lesson = schedules[menuCellIndexPath.section].lessons[menuCellIndexPath.row - 1] as LessonScheduleEntity
            let weeks = DateManager.scheduleWeeks()

            let viewController = segue.destination as! TeacherSchedulesPageViewController
            viewController.dateScheduleQuery = DateScheduleQuery(startWeekDate: weeks.first!.startDate, endWeekDate: weeks.first!.endDate)
            viewController.possibleWeeks = weeks
            viewController.teacher = lesson.teacher
        } else {
            super.prepare(for: segue, sender: sender)
        }

    }

}
