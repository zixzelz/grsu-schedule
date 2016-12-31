//
//  UserProfileViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/29/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet private var fullNameLabel: UILabel?
    @IBOutlet private var groupTitleLabel: UILabel?
    @IBOutlet private var studentTypeLabel: UILabel?
    
    var student: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fullNameLabel?.text = student?.fullName
        groupTitleLabel?.text = student?.groupTitle
        studentTypeLabel?.text = student?.studentType
    }
    
    @IBAction func cancelButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func logoutButtonPressed() {

        NSUserDefaults.student = nil
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.authenticationStateChanged, object: nil)

        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
