//
//  SelectScheduleOptionsViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/18/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import Armchair

class SelectScheduleOptionsViewController: UIViewController, ScheduleOptionsTableViewControllerDataSource, ScheduleOptionsTableViewControllerDelegate {

    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var loginBarButtonItem: UIBarButtonItem!

    var scheduleOptions: ScheduleOptionsTableViewController {
        get {
            return self.childViewControllers[0] as! ScheduleOptionsTableViewController
        }
    }

    var dateScheduleQuery: DateScheduleQuery = DateScheduleQuery()

    override func awakeFromNib() {
        super.awakeFromNib()
        navigationController?.title = L10n.studentTabbarTitle
        splitViewController?.tabBarItem?.setLocalizedTitle(L10n.studentTabbarTitle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        applyLargeTitles()

        scheduleOptions.scheduleDelegate = self
        scheduleOptions.scheduleDataSource = self
        updateShowScheduleButtonState()

        let inset = UIEdgeInsetsMake(0, 0, scheduleButton.frame.height, 0)
        scheduleOptions.tableView.contentInset = inset
        scheduleOptions.tableView.scrollIndicatorInsets = inset

        scrollToTop()

        scheduleButton.setLocalizedTitle(L10n.studentActionShowScheduleTitle)
        navigationItem.setLocalizedTitle(L10n.studentNavigationBarTitle)
        navigationItem.backBarButtonItem = UIBarButtonItem(localizedTitle: L10n.backBarButtonItemTitle, style: .plain, target: nil, action: nil)

        Armchair.showPromptIfNecessary()
    }

    private func applyLargeTitles() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(localizedTitle: L10n.backBarButtonItemTitle, style: .plain, target: nil, action: nil)
    }

    func scrollToTop() {
        let top = navigationController?.navigationBar.bounds.height ?? 44
        scheduleOptions.tableView.contentOffset = CGPoint(x: 0, y: -top)
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
        return fetchDefaultValue(.departmen)
    }

    func defaultFacultyID() -> String? {
        return fetchDefaultValue(.faculty)
    }

    func defaultCourse() -> String? {
        return fetchDefaultValue(.course)
    }

    func defaultGroupID() -> String? {
        return fetchDefaultValue(.group)
    }

    func defaultWeek() -> Date? {
        dateScheduleQuery.startWeekDate = fetchDefaultValue(.week)
        return dateScheduleQuery.startWeekDate
    }

    // MARK: - ScheduleOptionsTableViewControllerDelegate

    func didSelectDepartment(_ departmentId: String) {
        storeDefaultValue(.departmen, value: departmentId)
        updateShowScheduleButtonState()
    }

    func didSelectFaculty(_ facultyId: String) {
        storeDefaultValue(.faculty, value: facultyId)
        updateShowScheduleButtonState()
    }

    func didSelectCourse(_ course: String) {
        storeDefaultValue(.course, value: course)
        updateShowScheduleButtonState()
    }

    func didSelectGroup(_ groupId: String?) {
        storeDefaultValue(.group, value: groupId)
        updateShowScheduleButtonState()
    }

    func didSelectWeek(_ startWeekDate: Date) {
        dateScheduleQuery.startWeekDate = startWeekDate
        storeDefaultValue(.week, value: startWeekDate)
        updateShowScheduleButtonState()
    }

    // MARK: - Utils

    func storeDefaultValue<T>(_ key: ScheduleOption, value: T?) {
        let userDef = UserDefaults.standard
        userDef.set(value, forKey: key.rawValue)
    }

    func fetchDefaultValue<T>(_ key: ScheduleOption) -> T? {
        let userDef = UserDefaults.standard
        return userDef.object(forKey: key.rawValue) as? T
    }

}
