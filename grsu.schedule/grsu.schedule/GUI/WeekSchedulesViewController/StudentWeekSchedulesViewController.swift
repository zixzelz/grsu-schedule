//
//  StudentWeekSchedulesViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

class StudentWeekSchedulesViewController: WeekSchedulesViewController {

    var group: GroupsEntity?

    override func fetchData(useCache: Bool = true) {
        super.fetchData(useCache)

        GetStudentScheduleService.getSchedule(group!, dateStart: dateScheduleQuery!.startWeekDate!, dateEnd: dateScheduleQuery!.endWeekDate!, useCache: useCache) { [weak self](items: [LessonScheduleEntity]?, error: NSError?) -> Void in
            if (error == nil) {
                if let wSelf = self {
                    wSelf.setLessonSchedule(items!)
                    wSelf.reloadData()
                }
            } else {
                NSLog("GetStudentScheduleService error: \(error)")
            }
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
        lCell.teacherLabel.text = lesson.teacher.title

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
