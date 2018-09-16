//
//  MainTabBarController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/27/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

extension Notification.Name {
    static let authenticationStateChanged = Notification.Name("authenticationStateChanged")
}

class MainTabBarController: RAMAnimatedTabBarController {

    fileprivate var originalViewControllers: [UIViewController]?

    override func viewDidLoad() {
        super.viewDidLoad()

        originalViewControllers = viewControllers
        updateState(UserDefaults.student)

        setup()
    }

    fileprivate func setup() {

        NotificationCenter.default.addObserver(forName: .authenticationStateChanged, object: nil, queue: nil) { [weak self] notification in

            let student = notification.object as? Student
            self?.updateState(student)
        }
    }

    fileprivate func updateState(_ student: Student?) {

        var newTabs = originalViewControllers

        let authenticated = (student != nil)
        if !authenticated {
            newTabs?.removeFirst()
        }
        viewControllers = newTabs

        if authenticated {
            selectedIndex = 0
        }
    }
}
