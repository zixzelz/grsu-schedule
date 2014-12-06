//
//  StudentScheduleQuery.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class StudentScheduleQuery: NSObject {

    var group : GroupsEntity?
    var startWeekDate : NSDate?
    var endWeekDate : NSDate?
    
    override init() {
        super.init()
    }
    
    init(q: StudentScheduleQuery) {
        self.group = q.group
        self.startWeekDate = q.startWeekDate
        self.endWeekDate = q.endWeekDate
    }
}
