//
//  StudentLessonTableViewCell.swift
//  grsu.today
//
//  Created by Ruslan Maslouski on 07/11/2019.
//  Copyright © 2019 Ruslan Maslouski. All rights reserved.
//

import UIKit
import ServiceLayerSDK

class StudentLessonTableViewCell: UITableViewCell, CellIdentifier {

    @IBOutlet private(set) weak var studyNameLabel: UILabel!
    @IBOutlet private(set) weak var studyTypeLabel: UILabel!
    @IBOutlet private(set) weak var startTimeLabel: UILabel!
    @IBOutlet private(set) weak var stopTimeLabel: UILabel!

}

extension StudentLessonTableViewCell {
    func configure(with viewModel: StudentLessonCellViewModeling) {
        studyNameLabel.text = viewModel.name
        studyTypeLabel.text = viewModel.type
        startTimeLabel.text = viewModel.startTime
        stopTimeLabel.text = viewModel.stopTime
    }
}
