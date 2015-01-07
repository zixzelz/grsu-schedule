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
        
        GetTeacherScheduleService.getSchedule(teacher!, dateStart: dateScheduleQuery!.startWeekDate!, dateEnd: dateScheduleQuery!.endWeekDate!, useCache: false) { [weak self] (items: Array<LessonScheduleEntity>?, error: NSError?) -> Void in
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
        lCell.facultyLabel.text = groups.first?.faculty.title
        lCell.groupsLabel.text =  join(", ", titles)
        
        return lCell
    }

}
