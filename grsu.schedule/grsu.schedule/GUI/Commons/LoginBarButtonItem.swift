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

        updateState(UserDefaults.student)
        setup()
    }

    deinit {
        if let observer = notificationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    fileprivate func setup() {

        notificationObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Notification.authenticationStateChanged), object: nil, queue: nil) { [weak self] notification in

            let student = notification.object as? Student
            self?.updateState(student)
        }

        target = self
        action = #selector(LoginBarButtonItem.pressed)
    }

    fileprivate func updateState(_ student: Student?) {

        let authenticated = (student != nil)
        if !authenticated {
            title = "Войти"
            image = nil
        } else {
            title = nil
            image = UIImage(named: "UserTabBar")
        }
    }

    @objc func pressed() {

        let vc: UIViewController

        let student = UserDefaults.student
        let authenticated = (student != nil)
        if !authenticated {
            vc = UIStoryboard.authenticationViewController()
        } else {
            let profileViewController = UIStoryboard.profileViewController()
            profileViewController.student = student
            vc = profileViewController
        }

        let window = UIApplication.shared.keyWindow
        window?.rootViewController?.present(vc, animated: true, completion: nil)
    }

}
