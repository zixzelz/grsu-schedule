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
    
    var startTime : Int? {
        didSet {
            startTimeLabel.text = timeTextWithTimeInterval(startTime!)
        }
    }
    var stopTime : Int? {
        didSet {
            stopTimeLabel.text = timeTextWithTimeInterval(stopTime!)
        }
    }
    
    func timeTextWithTimeInterval(interval : Int) -> String {
        let h : Int = interval / 60
        let m : Int = interval % 60
        
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 2
        
        return formatter.stringFromNumber(h)! + ":" + formatter.stringFromNumber(m)!
    }
    
}
