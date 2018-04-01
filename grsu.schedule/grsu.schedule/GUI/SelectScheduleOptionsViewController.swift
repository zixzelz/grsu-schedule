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

        let inset = UIEdgeInsetsMake(0, 0, scheduleButton.frame.height, 0)
        scheduleOptions.tableView.contentInset = inset
        scheduleOptions.tableView.scrollIndicatorInsets = inset

        applyLargeTitles()
    }

    private func applyLargeTitles() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "SchedulePageIdentifier") {
            guard let group = scheduleOptions.selectedGroup() else { assertionFailure("Group is nil"); return }
            guard let week = scheduleOptions.selectedWeek() else { assertionFailure("Week is nil"); return }
            dateScheduleQuery.endWeekDate = week.endDate

            if let nc = segue.destination as? UINavigationController,
                let viewController = nc.topViewController as? StudentSchedulesPageViewController {
                viewController.dateScheduleQuery = dateScheduleQuery
                viewController.possibleWeeks = scheduleOptions.weeks
                viewController.configure(group)
            }
        }
    }

    func updateShowScheduleButtonState() {
        let group = scheduleOptions.selectedGroup()
        let enabled = group != nil && dateScheduleQuery.startWeekDate != nil

        let backgroundColor = enabled ? UIColor.interaction : UIColor.lightGray

        scheduleButton.isEnabled = enabled
        scheduleButton.backgroundColor = backgroundColor
    }

    // MARK: - ScheduleOptionsTableViewControllerDataSource

    func defaultDepartmentID() -> String? {
        return fetchDefaultValue(.departmen) as? String
    }

    func defaultFacultyID() -> String? {
        return fetchDefaultValue(.faculty) as? String
    }

    func defaultCourse() -> String? {
        return fetchDefaultValue(.course) as? String
    }

    func defaultGroupID() -> String? {
        return fetchDefaultValue(.group) as? String
    }

    func defaultWeek() -> Date? {
        dateScheduleQuery.startWeekDate = fetchDefaultValue(.week) as? Date
        return dateScheduleQuery.startWeekDate
    }

    // MARK: - ScheduleOptionsTableViewControllerDelegate

    func didSelectDepartment(_ departmentId: String) {
        storeDefaultValue(.departmen, value: departmentId as AnyObject)
        updateShowScheduleButtonState()
    }

    func didSelectFaculty(_ facultyId: String) {
        storeDefaultValue(.faculty, value: facultyId as AnyObject)
        updateShowScheduleButtonState()
    }

    func didSelectCourse(_ course: String) {
        storeDefaultValue(.course, value: course as AnyObject)
        updateShowScheduleButtonState()
    }

    func didSelectGroup(_ groupId: String?) {
        storeDefaultValue(.group, value: groupId as AnyObject)
        updateShowScheduleButtonState()
    }

    func didSelectWeek(_ startWeekDate: Date) {
        dateScheduleQuery.startWeekDate = startWeekDate
        storeDefaultValue(.week, value: startWeekDate as AnyObject)
        updateShowScheduleButtonState()
    }

    // MARK: - Utils

    func storeDefaultValue(_ key: ScheduleOption, value: AnyObject?) {
        let userDef = UserDefaults.standard
        userDef.set(value, forKey: key.rawValue)
    }

    func fetchDefaultValue(_ key: ScheduleOption) -> AnyObject? {
        let userDef = UserDefaults.standard
        return userDef.object(forKey: key.rawValue) as? String as AnyObject
    }

}
