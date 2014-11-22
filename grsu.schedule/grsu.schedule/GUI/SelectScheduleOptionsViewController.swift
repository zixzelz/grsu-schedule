//
//  SelectScheduleOptionsViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/18/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class SelectScheduleOptionsViewController: UIViewController, ScheduleOptionsTableViewControllerDataSource, ScheduleOptionsTableViewControllerDelegate {
    
    @IBOutlet weak var scheduleButton : UIButton!
    
    var scheduleOptions : ScheduleOptionsTableViewController {
        get {
            return self.childViewControllers[0] as ScheduleOptionsTableViewController
        }
    }
    
    var scheduleQuery : StudentScheduleQuery = StudentScheduleQuery()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleOptions.scheduleDelegate = self
        scheduleOptions.scheduleDataSource = self
        scheduleButton.enabled = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSUserDefaults.standardUserDefaults().synchronize()
        if (segue.identifier == "SchedulePageIdentifier") {
            let viewController = segue.destinationViewController as SchedulesPageViewController
            viewController.scheduleQuery = scheduleQuery
            viewController.possibleWeeks = scheduleOptions.weeks
        }
    }
    
    func updateShowScheduleButtonState() {
        let enabled = scheduleQuery.departmentId != nil && scheduleQuery.facultyId != nil && scheduleQuery.course != nil && scheduleQuery.groupId != nil && scheduleQuery.week != nil
        scheduleButton.enabled = enabled
    }
    
    // pragma mark - ScheduleOptionsTableViewControllerDataSource

    func defaultDepartmentID() -> String? {
        return fetchDefaultValue(.Departmen)
    }
    
    func defaultFacultyID() -> String? {
        return fetchDefaultValue(.Faculty)
    }
    
    func defaultCourse() -> String? {
        return fetchDefaultValue(.Course)
    }
    
    func defaultGroupID() -> String? {
        return fetchDefaultValue(.Group)
    }
    
    func defaultWeekID() -> String? {
        return fetchDefaultValue(.Week)
    }
    
    // pragma mark - ScheduleOptionsTableViewControllerDelegate
    
    func didSelectDepartment(departmentId : String) {
        scheduleQuery.departmentId = departmentId
        storeDefaultValue(.Departmen, value: departmentId)
        updateShowScheduleButtonState()
    }
    
    func didSelectFaculty(facultyId : String) {
        scheduleQuery.facultyId = facultyId
        storeDefaultValue(.Faculty, value: facultyId)
        updateShowScheduleButtonState()
    }
    
    func didSelectCourse(course : String) {
        scheduleQuery.course = course
        storeDefaultValue(.Group, value: course)
        updateShowScheduleButtonState()
    }
    
    func didSelectGroup(groupId : String) {
        scheduleQuery.groupId = groupId
        storeDefaultValue(.Course, value: groupId)
        updateShowScheduleButtonState()
    }
    
    func didSelectWeek(weekId : String) {
        scheduleQuery.week = weekId
        storeDefaultValue(.Week, value: weekId)
        updateShowScheduleButtonState()
    }
    
    // pragma mark - Utils
    
    func storeDefaultValue(key: ScheduleOption, value: String) {
        let userDef = NSUserDefaults.standardUserDefaults()
        userDef.setObject(value, forKey: key.rawValue)
    }

    func fetchDefaultValue(key: ScheduleOption) -> String? {
        let userDef = NSUserDefaults.standardUserDefaults()
        return userDef.objectForKey(key.rawValue) as? String
    }

}
