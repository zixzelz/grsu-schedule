//
//  StudentScheduleQuery.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class StudentScheduleQuery: NSObject {

    var departmentId : String?
    var facultyId : String?
    var groupId : String?
    var course : String?
    var week : String?
    
    override init() {
        super.init()
    }
    
    init(q: StudentScheduleQuery) {
        self.departmentId = q.departmentId
        self.facultyId = q.facultyId
        self.groupId = q.groupId
        self.course = q.course
        self.week = q.week
    }
}
