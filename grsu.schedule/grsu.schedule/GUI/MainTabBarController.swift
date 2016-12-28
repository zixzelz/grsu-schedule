//
//  MainTabBarController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/27/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

struct Notification {
    static let authenticationStateChanged = "authenticationStateChanged"
}

class MainTabBarController: UITabBarController {

    private var originalViewControllers: [UIViewController]?

    override func viewDidLoad() {
        super.viewDidLoad()

        originalViewControllers = viewControllers
        updateState(NSUserDefaults.student)

        setup()
    }

    private func setup() {

        NSNotificationCenter.defaultCenter().addObserverForName(Notification.authenticationStateChanged, object: nil, queue: nil) { [weak self] notification in
            
            let student = notification.object as? Student
            self?.updateState(student)
        }
    }

    private func updateState(student: Student?) {

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
