//
//  StudentScheduleQuery.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class StudentScheduleQuery: NSObject {

    var groupId : String?
    var startWeekDate : NSDate?
    var endWeekDate : NSDate?
    
    override init() {
        super.init()
    }
    
    init(q: StudentScheduleQuery) {
        self.groupId = q.groupId
        self.startWeekDate = q.startWeekDate
        self.endWeekDate = q.endWeekDate
    }
}
