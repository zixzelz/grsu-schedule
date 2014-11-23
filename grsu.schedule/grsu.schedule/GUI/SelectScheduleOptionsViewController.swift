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
        updateShowScheduleButtonState()
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
        
        var backgroundColor = enabled ? UIColor(red: 0.43529409170150757, green: 0.7450980544090271, blue: 0.21176469326019287, alpha: 1) : UIColor.lightGrayColor()
        
        scheduleButton.enabled = enabled
        scheduleButton.backgroundColor = backgroundColor
    }
    
    // pragma mark - ScheduleOptionsTableViewControllerDataSource

    func defaultDepartmentID() -> String? {
        scheduleQuery.departmentId = fetchDefaultValue(.Departmen)
        return scheduleQuery.departmentId
    }
    
    func defaultFacultyID() -> String? {
        scheduleQuery.facultyId = fetchDefaultValue(.Faculty)
        return scheduleQuery.facultyId
    }
    
    func defaultCourse() -> String? {
        scheduleQuery.course = fetchDefaultValue(.Course)
        return scheduleQuery.course
    }
    
    func defaultGroupID() -> String? {
        scheduleQuery.groupId = fetchDefaultValue(.Group)
        return scheduleQuery.groupId
    }
    
    func defaultWeekID() -> String? {
        scheduleQuery.week = fetchDefaultValue(.Week)
        return scheduleQuery.week
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
