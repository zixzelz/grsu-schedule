//
//  TeacherWeekSchedulesViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

class TeacherWeekSchedulesViewController: WeekSchedulesViewController {

    var teacher : TeacherInfoEntity?
    
    
    override func fetchData(useCache: Bool = true) {
        super.fetchData(useCache: useCache)
        
        GetTeacherScheduleService.getSchedule(teacher!, dateStart: dateScheduleQuery!.startWeekDate!, dateEnd: dateScheduleQuery!.endWeekDate!, useCache: true) { [weak self] (items: Array<LessonScheduleEntity>?, error: NSError?) -> Void in
            if (error == nil) {
                if let wSelf = self {
                    wSelf.setLessonSchedule(items!)
                    wSelf.reloadData()
                }
            } else {
                NSLog("GetTeacherScheduleService error: \(error)")
            }
        }
    }
    

    override func cellForLesson(lesson: LessonScheduleEntity, isActive: Bool) -> BaseLessonScheduleCell {
        var lCell: TeacherLessonScheduleCell
        if (isActive) {
            let identifier = "TeacherActiveLessonScheduleCellIdentifier"
            lCell = tableView.dequeueReusableCellWithIdentifier(identifier) as TeacherActiveLessonScheduleCell
        } else {
            let identifier = "TeacherLessonScheduleCellIdentifier"
            lCell = tableView.dequeueReusableCellWithIdentifier(identifier) as TeacherLessonScheduleCell
        }
        
        let groups = lesson.groups.allObjects as [GroupsEntity]
        let titles = groups.map { $0.title } as [String]
        lCell.facultyLabel.text = groups.first?.faculty?.title
        lCell.groupsLabel.text =  join(", ", titles)
        
        return lCell
    }
    
    @IBAction func groupScheduleMenuButtonPressed(sender: UIButton) {
        var lesson = schedules![menuCellIndexPath!.section].lessons[menuCellIndexPath!.row-1] as LessonScheduleEntity
        if (lesson.groups.count == 1) {
            self.presentGroupSchedule(lesson.groups.allObjects.first as GroupsEntity)
        } else {
            chooseGroup(lesson.groups.allObjects as [GroupsEntity])
        }
    }
    
    func chooseGroup(groups: [GroupsEntity]) {
        
        #if giOS8OrGreater
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
        #else

            let al = UIAlertView(title: "", message: "Пока только в iOS 8.", delegate: nil, cancelButtonTitle: "OK")
            al.show()
            
        #endif

    }

    func presentGroupSchedule(group: GroupsEntity) {
        performSegueWithIdentifier("StudentSchedulePageIdentifier", sender: group)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "StudentSchedulePageIdentifier") {
            let weeks = DateManager.scheduleWeeks()
            
            let viewController = segue.destinationViewController as StudentSchedulesPageViewController
            viewController.dateScheduleQuery = DateScheduleQuery(startWeekDate: weeks.first!.startDate, endWeekDate: weeks.first!.endDate)
            viewController.possibleWeeks = weeks
            viewController.group = sender as? GroupsEntity
            
        } else {
            super.prepareForSegue(segue, sender: sender)
        }
    }
    
}
