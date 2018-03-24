//
//  TeacherPhotoTableViewCell.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/11/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class TeacherPhotoTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var photoImageView: UIImageView!
    @IBOutlet fileprivate weak var fullNameLabel: UILabel!
    @IBOutlet fileprivate weak var jobTitle: UILabel!

    override var imageView: UIImageView? {
        get {
            return photoImageView
        }
    }

    override var textLabel: UILabel? {
        get {
            return fullNameLabel
        }
    }

    override var detailTextLabel: UILabel? {
        get {
            return jobTitle
        }
    }

}
