//
//  TeacherPhotoTableViewCell.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/11/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class TeacherPhotoTableViewCell: UITableViewCell {

    @IBOutlet private weak var photoImageView : UIImageView!
    @IBOutlet private weak var fullNameLabel : UILabel!
    
    override var imageView: UIImageView? { get {
        return photoImageView
        }}

    override var textLabel: UILabel? { get {
        return fullNameLabel
        }}
    
    
}
