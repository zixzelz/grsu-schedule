//
//  SelectScheduleOptionsViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/18/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class SelectScheduleOptionsViewController: UIViewController, ScheduleOptionsTableViewControllerDelegate, ScheduleOptionsTableViewControllerDataSource {
    
    var scheduleOptions : ScheduleOptionsTableViewController {
        get {
            return self.childViewControllers[0] as ScheduleOptionsTableViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleOptions.scheduleDelegate = self
        scheduleOptions.scheduleDataSource = self
    }
    
    @IBAction func showScheduleButtonPressed(sender: AnyObject) {
        
    }
    
}
