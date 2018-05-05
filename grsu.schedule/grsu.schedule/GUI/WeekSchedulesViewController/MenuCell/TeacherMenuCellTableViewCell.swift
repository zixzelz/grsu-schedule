//
//  TeacherMenuCellTableViewCell.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 5/5/18.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit

class TeacherMenuCellTableViewCell: UITableViewCell {

    @IBOutlet private var lessonLocationButton: UIButton!
    @IBOutlet private var groupScheduleButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        lessonLocationButton.setTitle(L10n.scheduleActionMenuRoom, for: .normal)
        groupScheduleButton.setTitle(L10n.scheduleActionMenuGroupSchedule, for: .normal)
    }

}
