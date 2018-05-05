//
//  StudentMenuCellTableViewCell.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 5/5/18.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit

class StudentMenuCellTableViewCell: UITableViewCell {

    @IBOutlet private var lessonLocationButton: UIButton!
    @IBOutlet private var teacherScheduleButton: UIButton!
    @IBOutlet private var teacherInfoButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        lessonLocationButton.setTitle(L10n.scheduleActionMenuRoom, for: .normal)
        teacherScheduleButton.setTitle(L10n.scheduleActionMenuTeacherSchedule, for: .normal)
        teacherInfoButton.setTitle(L10n.scheduleActionMenuTeacherInfo, for: .normal)
    }

}
