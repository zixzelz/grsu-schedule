//
//  StudentScheduleQuery.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class DateScheduleQuery: NSObject {

    var startWeekDate : NSDate?
    var endWeekDate : NSDate?
    
    override init() {
        super.init()
    }
    
    init(startWeekDate : NSDate, endWeekDate : NSDate) {
        self.startWeekDate = startWeekDate;
        self.endWeekDate = endWeekDate;
    }
}
