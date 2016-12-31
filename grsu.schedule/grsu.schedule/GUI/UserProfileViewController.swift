//
//  UserProfileViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/29/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    var student: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func logoutButtonPressed() {

        NSUserDefaults.student = nil
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.authenticationStateChanged, object: student)

        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
