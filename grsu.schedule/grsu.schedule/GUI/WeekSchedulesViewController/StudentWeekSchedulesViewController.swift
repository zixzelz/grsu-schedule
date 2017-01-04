//
//  StudentWeekSchedulesViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

class StudentWeekSchedulesViewController: WeekSchedulesViewController {

    private var group: GroupsEntity?
    private var studentId: String?

    func configureWithStudent(studentId: String, dateScheduleQuery: DateScheduleQuery) {
        self.studentId = studentId
        self.dateScheduleQuery = dateScheduleQuery
    }

    func configureWithGroup(group: GroupsEntity, dateScheduleQuery: DateScheduleQuery) {
        self.group = group
        self.dateScheduleQuery = dateScheduleQuery
    }

    override func fetchData(useCache: Bool = true, animated: Bool) {
        super.fetchData(useCache, animated: animated)

        guard let startWeekDate = dateScheduleQuery?.startWeekDate, let endWeekDate = dateScheduleQuery?.endWeekDate else {
            assertionFailure("Miss param query:\(self.dateScheduleQuery)")
            return
        }

        let cache: CachePolicy = useCache ? .CachedElseLoad : .ReloadIgnoringCache
        fetchDataWithStudentId(startWeekDate, dateEnd: endWeekDate, cache: cache) { [weak self] result -> Void in

            guard let strongSelf = self else { return }
            guard case let .Success(items) = result else { return }

            strongSelf.setLessonSchedule(items)
            strongSelf.reloadData(animated)
        }
    }
    
    private func fetchDataWithStudentId(dateStart: NSDate, dateEnd: NSDate, cache: CachePolicy, completionHandler: StudentScheduleCompletionHandlet) {

        if let group = group {
            ScheduleService().getStudentSchedule(group, dateStart: dateStart, dateEnd: dateEnd, cache: cache, completionHandler: completionHandler)
        } else if let studentId = studentId {
            ScheduleService().getMySchedule(studentId, dateStart: dateStart, dateEnd: dateEnd, cache: cache, completionHandler: completionHandler)
        } else {
            assertionFailure("Miss params group and studentId")
        }
    }
    
    override func cellForLesson(lesson: LessonScheduleEntity, isActive: Bool) -> BaseLessonScheduleCell {

        var lCell: StudentLessonScheduleCell
        if (isActive) {
            let identifier = "StudentActiveLessonScheduleCellIdentifier"
            lCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! StudentActiveLessonScheduleCell
        } else {
            let identifier = "StudentLessonScheduleCellIdentifier"
            lCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! StudentLessonScheduleCell
        }

        lCell.subgroupTitleLabel.text = !NSString.isNilOrEmpty(lesson.subgroupTitle) ? "Подгруппа: \(lesson.subgroupTitle!)" : ""
        lCell.teacherLabel.text = lesson.teacher?.title

        return lCell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if (segue.identifier == "TeacherInfoIdentifier") {

            let lesson = schedules![menuCellIndexPath!.section].lessons[menuCellIndexPath!.row - 1] as LessonScheduleEntity

            let viewController = segue.destinationViewController as! TeacherInfoViewController
            viewController.teacherInfo = lesson.teacher

        } else if (segue.identifier == "TeacherSchedulePageIdentifier") {

            let lesson = schedules![menuCellIndexPath!.section].lessons[menuCellIndexPath!.row - 1] as LessonScheduleEntity
            let weeks = DateManager.scheduleWeeks()

            let viewController = segue.destinationViewController as! TeacherSchedulesPageViewController
            viewController.dateScheduleQuery = DateScheduleQuery(startWeekDate: weeks.first!.startDate, endWeekDate: weeks.first!.endDate)
            viewController.possibleWeeks = weeks
            viewController.teacher = lesson.teacher
        } else {
            super.prepareForSegue(segue, sender: sender)
        }

    }

}
