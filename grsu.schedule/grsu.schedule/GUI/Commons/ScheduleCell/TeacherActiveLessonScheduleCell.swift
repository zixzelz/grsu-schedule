//
//  TeacherActiveLessonScheduleCell.swift
//  grsu.schedule
//
//  Created by Ruslan on 07.01.15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

class TeacherActiveLessonScheduleCell: TeacherLessonScheduleCell, ActiveLessonScheduleCell {
    @IBOutlet private(set) weak var lessonProgressView : UIProgressView!
}
