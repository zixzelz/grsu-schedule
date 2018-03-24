//
//  UserProfileViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/29/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet fileprivate var fullNameLabel: UILabel?
    @IBOutlet fileprivate var groupTitleLabel: UILabel?
    @IBOutlet fileprivate var studentTypeLabel: UILabel?
    
    var student: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fullNameLabel?.text = student?.fullName
        groupTitleLabel?.text = student?.groupTitle
        studentTypeLabel?.text = student?.studentType
    }
    
    @IBAction func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func logoutButtonPressed() {

        UserDefaults.student = nil
        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: Notification.authenticationStateChanged), object: nil)

        dismiss(animated: true, completion: nil)
    }
    
}
