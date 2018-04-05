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
    @IBOutlet private weak var userSignOutButton: UIButton!
//    @IBOutlet private weak var userBackButton: UIButton!

    var student: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fullNameLabel?.text = student?.fullName
        groupTitleLabel?.text = student?.groupTitle
        studentTypeLabel?.text = student?.studentType

//        userBackButton.setTitle(L10n.anyScreenActionBack, for: .normal)
        userSignOutButton.setTitle(L10n.userProfileActionSignout, for: .normal)
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
