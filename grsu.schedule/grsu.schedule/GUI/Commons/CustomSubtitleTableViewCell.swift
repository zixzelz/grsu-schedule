//
//  CustomSubtitleTableViewCell.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/14/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class CustomSubtitleTableViewCell: UITableViewCell {

    @IBOutlet private weak var customTextLabel : UILabel!
    @IBOutlet private weak var customDetailTextLabel : UILabel!
    
    override var textLabel: UILabel? { get {
        return customTextLabel
        }}
    
    override var detailTextLabel: UILabel? { get {
        return customDetailTextLabel
        }}

}
