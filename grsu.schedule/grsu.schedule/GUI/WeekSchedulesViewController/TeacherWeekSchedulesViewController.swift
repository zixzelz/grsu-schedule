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

    override func fetchData(_ useCache: Bool = true, animated: Bool) {
        super.fetchData(useCache, animated: animated)

        guard let teacher = teacher, let startWeekDate = dateScheduleQuery?.startWeekDate, let endWeekDate = dateScheduleQuery?.endWeekDate else {
            assertionFailure("Miss params")
            return
        }

        let cache: CachePolicy = useCache ? .cachedElseLoad : .reloadIgnoringCache
        ScheduleService().getTeacherSchedule(teacher, dateStart: startWeekDate, dateEnd: endWeekDate, cache: cache) { [weak self] result -> Void in

            guard let strongSelf = self else { return }

            switch result {
            case .success(let items):
                strongSelf.setLessonSchedule(items)
            case .failure(let error):
                Flurry.logError(error, errId: "TeacherWeekSchedulesViewController")
                strongSelf.showMessage(L10n.loadingFailedMessage)
            }
            strongSelf.reloadData(animated)
        }
    }

    override func configure(_ cell: LessonScheduleCell, lesson: LessonScheduleEntity) {
        cell.configureTeacher(lesson)
    }

    @IBAction func groupScheduleMenuButtonPressed(_ sender: UIButton) {

        let lesson = schedules![menuCellIndexPath!.section].lessons[menuCellIndexPath!.row - 1] as LessonScheduleEntity

        if (lesson.groups.count == 1) {
            self.presentGroupSchedule(lesson.groups.first!)
        } else {
            chooseGroup(lesson.groups)
        }
    }

    func chooseGroup(_ groups: Set<GroupsEntity>) {

        let alert = UIAlertController(title: L10n.scheduleSelectGroupTitle, message: "", preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        for group in groups {
            let action = UIAlertAction(title: group.title, style: .default) { _ in
                self.presentGroupSchedule(group)
            }
            alert.addAction(action)
        }

        present(alert, animated: true, completion: nil)
    }

    func presentGroupSchedule(_ group: GroupsEntity) {
        performSegue(withIdentifier: "StudentSchedulePageIdentifier", sender: group)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "StudentSchedulePageIdentifier") {
            guard let group = sender as? GroupsEntity else { assertionFailure("sender is not GroupsEntity"); return }
            let weeks = DateManager.scheduleWeeks()

            let viewController = segue.destination as! StudentSchedulesPageViewController
            viewController.dateScheduleQuery = DateScheduleQuery(startWeekDate: weeks.first!.startDate, endWeekDate: weeks.first!.endDate)
            viewController.possibleWeeks = weeks
            viewController.configure(group)

        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

}
