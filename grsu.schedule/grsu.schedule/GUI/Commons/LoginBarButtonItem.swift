//
//  LoginBarButtonItem.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/31/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

class LoginBarButtonItem: UIBarButtonItem {

    var notificationObserver: AnyObject?

    override func awakeFromNib() {
        super.awakeFromNib()

        updateState(NSUserDefaults.student)
        setup()
    }

    deinit {
        if let observer = notificationObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
    }

    private func setup() {

        notificationObserver = NSNotificationCenter.defaultCenter().addObserverForName(Notification.authenticationStateChanged, object: nil, queue: nil) { [weak self] notification in

            let student = notification.object as? Student
            self?.updateState(student)
        }

        target = self
        action = #selector(LoginBarButtonItem.pressed)
    }

    private func updateState(student: Student?) {

        let authenticated = (student != nil)
        if !authenticated {
            title = "Войти"
            image = nil
        } else {
            title = nil
            image = UIImage(named: "UserTabBar")
        }
    }

    func pressed() {

        let vc: UIViewController

        let student = NSUserDefaults.student
        let authenticated = (student != nil)
        if !authenticated {
            vc = UIStoryboard.authenticationViewController()
        } else {
            let profileViewController = UIStoryboard.profileViewController()
            profileViewController.student = student
            vc = profileViewController
        }

        let window = UIApplication.sharedApplication().keyWindow
        window?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
    }

}
