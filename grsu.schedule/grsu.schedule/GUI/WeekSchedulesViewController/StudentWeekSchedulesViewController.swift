//
//  StudentWeekSchedulesViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

class StudentWeekSchedulesViewController: WeekSchedulesViewController {

    var group : GroupsEntity?

    
    override func fetchData(useCache: Bool = true) {
        super.fetchData(useCache: useCache)
        
        GetStudentScheduleService.getSchedule(group!, dateStart: dateScheduleQuery!.startWeekDate!, dateEnd: dateScheduleQuery!.endWeekDate!, useCache: useCache) { [weak self] (items: Array<StudentDayScheduleEntity>?, error: NSError?) -> Void in
            if let wSelf = self {
                wSelf.schedules = items
                wSelf.reloadData()
            }
        }
    }

}
