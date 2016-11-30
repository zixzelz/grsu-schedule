//
//  TeacherWeekSchedulesViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

class TeacherWeekSchedulesViewController: WeekSchedulesViewController {

    var teacher: TeacherInfoEntity?

    override func fetchData(useCache: Bool = true) {
        super.fetchData(useCache)

        let cache: CachePolicy = useCache ? .CachedElseLoad : .ReloadIgnoringCache
        ScheduleService().getTeacherSchedule(teacher!, dateStart: dateScheduleQuery!.startWeekDate!, dateEnd: dateScheduleQuery!.endWeekDate!, cache: cache) { [weak self] result -> Void in

            guard let strongSelf = self else { return }
            guard case let .Success(items) = result else { return }

            strongSelf.setLessonSchedule(items)
            strongSelf.reloadData()
        }
    }

    override func cellForLesson(lesson: LessonScheduleEntity, isActive: Bool) -> BaseLessonScheduleCell {
        var lCell: TeacherLessonScheduleCell
        if (isActive) {
            let identifier = "TeacherActiveLessonScheduleCellIdentifier"
            lCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! TeacherActiveLessonScheduleCell
        } else {
            let identifier = "TeacherLessonScheduleCellIdentifier"
            lCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! TeacherLessonScheduleCell
        }

        let groups = lesson.groups
        let titles = groups.map { $0.title } as [String]
        lCell.facultyLabel.text = groups.first?.faculty?.title
        lCell.groupsLabel.text = titles.joinWithSeparator(", ")

        return lCell
    }

    @IBAction func groupScheduleMenuButtonPressed(sender: UIButton) {

        let lesson = schedules![menuCellIndexPath!.section].lessons[menuCellIndexPath!.row - 1] as LessonScheduleEntity

        if (lesson.groups.count == 1) {
            self.presentGroupSchedule(lesson.groups.first!)
        } else {
            chooseGroup(lesson.groups)
        }
    }

    func chooseGroup(groups: Set<GroupsEntity>) {

        if #available(iOS 8, *) {

            let alert = UIAlertController(title: "Выбор группы:", message: "", preferredStyle: .ActionSheet)

            let cancelAction = UIAlertAction(title: "Отмена", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)

            for group in groups {
                let action = UIAlertAction(title: group.title, style: .Default) { _ in
                    self.presentGroupSchedule(group)
                }
                alert.addAction(action)
            }

            self.presentViewController(alert, animated: true, completion: nil)
        } else {

            let al = UIAlertView(title: "", message: "Пока только в iOS 8.", delegate: nil, cancelButtonTitle: "OK")
            al.show()

        }

    }

    func presentGroupSchedule(group: GroupsEntity) {
        performSegueWithIdentifier("StudentSchedulePageIdentifier", sender: group)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if (segue.identifier == "StudentSchedulePageIdentifier") {
            let weeks = DateManager.scheduleWeeks()

            let viewController = segue.destinationViewController as! StudentSchedulesPageViewController
            viewController.dateScheduleQuery = DateScheduleQuery(startWeekDate: weeks.first!.startDate, endWeekDate: weeks.first!.endDate)
            viewController.possibleWeeks = weeks
            viewController.group = sender as? GroupsEntity

        } else {
            super.prepareForSegue(segue, sender: sender)
        }
    }

}
