//
//  StudentScheduleQuery.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class BaseScheduleQuery: NSObject {

    var startWeekDate : NSDate?
    var endWeekDate : NSDate?
}

class StudentScheduleQuery: BaseScheduleQuery {
    
    var group : GroupsEntity?
    
    override init() {
        
    }
    
    init(studentQuery: StudentScheduleQuery) {
        super.init()
        self.startWeekDate = studentQuery.startWeekDate
        self.endWeekDate = studentQuery.endWeekDate
        self.group = studentQuery.group
    }
}
