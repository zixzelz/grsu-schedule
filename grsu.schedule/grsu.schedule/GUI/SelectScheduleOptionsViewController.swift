//
//  SelectScheduleOptionsViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/18/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class SelectScheduleOptionsViewController: UIViewController, ScheduleOptionsTableViewControllerDataSource, ScheduleOptionsTableViewControllerDelegate {

    @IBOutlet weak var scheduleButton: UIButton!

    var scheduleOptions: ScheduleOptionsTableViewController {
        get {
            return self.childViewControllers[0] as! ScheduleOptionsTableViewController
        }
    }

    var dateScheduleQuery: DateScheduleQuery = DateScheduleQuery()

    override func viewDidLoad() {
        super.viewDidLoad()

        scheduleOptions.scheduleDelegate = self
        scheduleOptions.scheduleDataSource = self
        updateShowScheduleButtonState()

        let inset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(scheduleButton.frame), 0)
        scheduleOptions.tableView.contentInset = inset
        scheduleOptions.tableView.scrollIndicatorInsets = inset
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        NSUserDefaults.standardUserDefaults().synchronize()
        if (segue.identifier == "SchedulePageIdentifier") {
            let group = scheduleOptions.selectedGroup()
            let week = scheduleOptions.selectedWeek()
            dateScheduleQuery.endWeekDate = week!.endDate

            let viewController = segue.destinationViewController as! StudentSchedulesPageViewController
            viewController.dateScheduleQuery = dateScheduleQuery
            viewController.possibleWeeks = scheduleOptions.weeks
            viewController.group = group
        }
    }

    func updateShowScheduleButtonState() {
        let group = scheduleOptions.selectedGroup()
        let enabled = group != nil && dateScheduleQuery.startWeekDate != nil

        let backgroundColor = enabled ? UIColor(red: 0.43529409170150757, green: 0.7450980544090271, blue: 0.21176469326019287, alpha: 1) : UIColor.lightGrayColor()

        scheduleButton.enabled = enabled
        scheduleButton.backgroundColor = backgroundColor
    }

    // MARK: - ScheduleOptionsTableViewControllerDataSource

    func defaultDepartmentID() -> String? {
        return fetchDefaultValue(.Departmen) as? String
    }

    func defaultFacultyID() -> String? {
        return fetchDefaultValue(.Faculty) as? String
    }

    func defaultCourse() -> String? {
        return fetchDefaultValue(.Course) as? String
    }

    func defaultGroupID() -> String? {
        return fetchDefaultValue(.Group) as? String
    }

    func defaultWeek() -> NSDate? {
        dateScheduleQuery.startWeekDate = fetchDefaultValue(.Week) as? NSDate
        return dateScheduleQuery.startWeekDate
    }

    // MARK: - ScheduleOptionsTableViewControllerDelegate

    func didSelectDepartment(departmentId: String) {
        storeDefaultValue(.Departmen, value: departmentId)
        updateShowScheduleButtonState()
    }

    func didSelectFaculty(facultyId: String) {
        storeDefaultValue(.Faculty, value: facultyId)
        updateShowScheduleButtonState()
    }

    func didSelectCourse(course: String) {
        storeDefaultValue(.Course, value: course)
        updateShowScheduleButtonState()
    }

    func didSelectGroup(groupId: String?) {
        storeDefaultValue(.Group, value: groupId)
        updateShowScheduleButtonState()
    }

    func didSelectWeek(startWeekDate: NSDate) {
        dateScheduleQuery.startWeekDate = startWeekDate
        storeDefaultValue(.Week, value: startWeekDate)
        updateShowScheduleButtonState()
    }

    // MARK: - Utils

    func storeDefaultValue(key: ScheduleOption, value: AnyObject?) {
        let userDef = NSUserDefaults.standardUserDefaults()
        userDef.setObject(value, forKey: key.rawValue)
    }

    func fetchDefaultValue(key: ScheduleOption) -> AnyObject? {
        let userDef = NSUserDefaults.standardUserDefaults()
        return userDef.objectForKey(key.rawValue) as? String
    }

}
