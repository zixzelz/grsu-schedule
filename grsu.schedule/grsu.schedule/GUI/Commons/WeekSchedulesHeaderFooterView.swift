//
//  WeekSchedulesHeaderFooterView.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/27/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class WeekSchedulesHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet fileprivate weak var textLabel_: UILabel!
    
    override var textLabel: UILabel? {
        return textLabel_
    }
}
