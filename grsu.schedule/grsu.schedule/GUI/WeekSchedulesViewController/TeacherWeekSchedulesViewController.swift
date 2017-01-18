//
//  TeacherWeekSchedulesViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class TeacherWeekSchedulesViewController: WeekSchedulesViewController {

    var teacher: TeacherInfoEntity?

    override func fetchData(useCache: Bool = true, animated: Bool) {
        super.fetchData(useCache, animated: animated)

        guard let teacher = teacher, let startWeekDate = dateScheduleQuery?.startWeekDate, let endWeekDate = dateScheduleQuery?.endWeekDate else {
            assertionFailure("Miss params")
            return
        }

        let cache: CachePolicy = useCache ? .CachedElseLoad : .ReloadIgnoringCache
        ScheduleService().getTeacherSchedule(teacher, dateStart: startWeekDate, dateEnd: endWeekDate, cache: cache) { [weak self] result -> Void in

            guard let strongSelf = self else { return }
            
            switch result {
            case .Success(let items):
                strongSelf.setLessonSchedule(items)
            case .Failure(let error):
                
                Flurry.logError(error, errId: "TeacherWeekSchedulesViewController")
                strongSelf.showMessage("Ошибка при получении данных")
            }
            strongSelf.reloadData(animated)
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

        let alert = UIAlertController(title: "Выбор группы:", message: "", preferredStyle: .ActionSheet)

        let cancelAction = UIAlertAction(title: "Отмена", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)

        for group in groups {
            let action = UIAlertAction(title: group.title, style: .Default) { _ in
                self.presentGroupSchedule(group)
            }
            alert.addAction(action)
        }

        presentViewController(alert, animated: true, completion: nil)
    }
 
    func presentGroupSchedule(group: GroupsEntity) {
        performSegueWithIdentifier("StudentSchedulePageIdentifier", sender: group)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if (segue.identifier == "StudentSchedulePageIdentifier") {
            guard let group = sender as? GroupsEntity else { assertionFailure("sender is not GroupsEntity"); return }
            let weeks = DateManager.scheduleWeeks()

            let viewController = segue.destinationViewController as! StudentSchedulesPageViewController
            viewController.dateScheduleQuery = DateScheduleQuery(startWeekDate: weeks.first!.startDate, endWeekDate: weeks.first!.endDate)
            viewController.possibleWeeks = weeks
            viewController.configure(group)

        } else {
            super.prepareForSegue(segue, sender: sender)
        }
    }

}
