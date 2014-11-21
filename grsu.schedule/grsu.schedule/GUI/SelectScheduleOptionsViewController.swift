//
//  SelectScheduleOptionsViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/18/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class SelectScheduleOptionsViewController: UIViewController {
    
    var scheduleOptions : ScheduleOptionsTableViewController {
        get {
            return self.childViewControllers[0] as ScheduleOptionsTableViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SchedulePageIdentifier") {
            let scheduleQuery = StudentScheduleQuery()
            
            let viewController = segue.destinationViewController as SchedulesPageViewController
            viewController.scheduleQuery = scheduleQuery
        }
    }
}
