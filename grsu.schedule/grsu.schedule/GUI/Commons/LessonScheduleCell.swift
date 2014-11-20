//
//  LessonScheduleCell.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class LessonScheduleCell: UITableViewCell {

    @IBOutlet private(set) weak var locationLabel : UILabel!
    @IBOutlet private(set) weak var studyNameLabel : UILabel!
    @IBOutlet private(set) weak var teacherLabel : UILabel!
    @IBOutlet private weak var startTimeLabel : UILabel!
    @IBOutlet private weak var stopTimeLabel : UILabel!

    var startTime : NSDate?
    var stopTime : NSDate?
    
}
