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
        
//        GetStudentScheduleService.getSchedule(scheduleQuery!.group!, dateStart: scheduleQuery!.startWeekDate!, dateEnd: scheduleQuery!.endWeekDate!, useCache: useCache) { [weak self] (items: Array<StudentDayScheduleEntity>?, error: NSError?) -> Void in
//            if let wSelf = self {
//                wSelf.schedules = items
                self.reloadData()
//            }
//        }
    }

}
