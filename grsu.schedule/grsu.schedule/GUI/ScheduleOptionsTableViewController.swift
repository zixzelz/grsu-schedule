//
//  SelectScheduleOptionsViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/11/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import ServiceLayerSDK

protocol ScheduleOptionsTableViewControllerDelegate: NSObjectProtocol {
    func didSelectDepartment(_ departmentId: String)
    func didSelectFaculty(_ facultyId: String)
    func didSelectCourse(_ course: String)
    func didSelectGroup(_ groupId: String?)
    func didSelectWeek(_ startDate: Date)
}

protocol ScheduleOptionsTableViewControllerDataSource: NSObjectProtocol {
    func defaultDepartmentID() -> String?
    func defaultFacultyID() -> String?
    func defaultCourse() -> String?
    func defaultGroupID() -> String?
    func defaultWeek() -> Date?
}

class ScheduleOptionsTableViewController: UITableViewController, PickerTableViewCellDelegate {

    @IBOutlet fileprivate weak var departmentTableViewCell: UITableViewCell!
    @IBOutlet fileprivate weak var facultyTableViewCell: UITableViewCell!
    @IBOutlet fileprivate weak var courseTableViewCell: UITableViewCell!
    @IBOutlet fileprivate weak var groupTableViewCell: UITableViewCell!
    @IBOutlet fileprivate weak var timeTableViewCell: UITableViewCell!

    @IBOutlet fileprivate weak var departmentPickerTableViewCell: PickerTableViewCell!
    @IBOutlet fileprivate weak var facultyPickerTableViewCell: PickerTableViewCell!
    @IBOutlet fileprivate weak var coursePickerTableViewCell: PickerTableViewCell!
    @IBOutlet fileprivate weak var groupPickerTableViewCell: PickerTableViewCell!
    @IBOutlet fileprivate weak var weekPickerTableViewCell: PickerTableViewCell!

    fileprivate var departments: Array<DepartmentsEntity>?
    fileprivate var faculties: Array<FacultiesEntity>?
    fileprivate var groups: Array<GroupsEntity>?
    fileprivate(set) var weeks: Array<GSWeekItem>!

    weak var scheduleDelegate: ScheduleOptionsTableViewControllerDelegate?
    weak var scheduleDataSource: ScheduleOptionsTableViewControllerDataSource?
    fileprivate var selectedCell: NSInteger = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { () -> Void in
            self.setupPickerCells()
        }

        departmentTableViewCell.textLabel?.setLocalizedTitle(L10n.studentFilterDepartmentTitle)
        facultyTableViewCell.textLabel?.setLocalizedTitle(L10n.studentFilterFacultyTitle)
        courseTableViewCell.textLabel?.setLocalizedTitle(L10n.studentFilterCourseTitle)
        groupTableViewCell.textLabel?.setLocalizedTitle(L10n.studentFilterGroupTitle)
        timeTableViewCell.textLabel?.setLocalizedTitle(L10n.studentFilterWeekTitle)

        NotificationCenter.default.reactive.notifications(forName: .languageDidChanged)
            .take(duringLifetimeOf: self)
            .observeValues { [weak self] _ in
                self?.featchData(cachePolicy: .reloadIgnoringCache)
        }
    }

    func setupPickerCells() {

        let courses = ["1", "2", "3", "4", "5", "6"]
        coursePickerTableViewCell.items = courses
        if let item = scheduleDataSource?.defaultCourse() {
            coursePickerTableViewCell.selectRow(item)
        } else {
            self.scheduleDelegate?.didSelectCourse(courses.first!)
        }

        weeks = DateManager.scheduleWeeks()
        weekPickerTableViewCell.items = weeks!.map { $0.value }

        if let startWeekDate = scheduleDataSource?.defaultWeek(),
            let item = weeks.filter ({ $0.startDate as Date == startWeekDate }).first {
            weekPickerTableViewCell.selectRow(item.value)
        } else {
            self.scheduleDelegate?.didSelectWeek(weeks.first!.startDate as Date)
        }

        featchData()
    }

    private lazy var departmentsService: DepartmentsService = {
        return DepartmentsService()
    }()

    func featchData(cachePolicy: CachePolicy = .cachedElseLoad) {

        departmentsService.getDepartments(cachePolicy)
            .flatMap(.latest) { $0.items(in: CoreDataHelper.managedObjectContext) }
            .startWithResult { [weak self] result in
                guard let strongSelf = self else { return }
                guard case let .success(items) = result else { return }

                strongSelf.departments = items
                strongSelf.departmentPickerTableViewCell.items = items.map { $0.title }

                if let itemId = strongSelf.scheduleDataSource?.defaultDepartmentID() {

                    if let value = strongSelf.valueById(items, itemId: itemId) {
                        strongSelf.departmentPickerTableViewCell.selectRow(value)
                    } else {
                        if let id = items.first?.id {
                            strongSelf.scheduleDelegate?.didSelectDepartment(id)
                        }
                    }
                }

                strongSelf.featchGroups(cachePolicy: cachePolicy)
        }

        FacultyService().getFaculties(cachePolicy)
            .flatMap(.latest) { $0.items(in: CoreDataHelper.managedObjectContext) }
            .startWithResult { [weak self] result in

                guard let strongSelf = self else { return }
                guard case let .success(items) = result else { return }

                strongSelf.faculties = items
                strongSelf.facultyPickerTableViewCell.items = items.map { $0.title }

                if let itemId = strongSelf.scheduleDataSource?.defaultFacultyID() {

                    if let value = strongSelf.valueById(items, itemId: itemId) {
                        strongSelf.facultyPickerTableViewCell.selectRow(value)
                    } else {
                        if let id = items.first?.id {
                            strongSelf.scheduleDelegate?.didSelectFaculty(id)
                        }
                    }
                }

                strongSelf.featchGroups(cachePolicy: cachePolicy)
        }
    }

    func featchGroups(cachePolicy: CachePolicy) {

        guard let faculty = selectedFaculty(), let departmant = selectedDepartment(), let course = selectedCourse() else {
            return
        }

        GroupsService().getGroups(faculty, department: departmant, course: course)
            .flatMap(.latest) { $0.items(in: CoreDataHelper.managedObjectContext) }
            .startWithResult { [weak self] result in

                guard let strongSelf = self else { return }
                guard case let .success(items) = result else { return }

                strongSelf.groups = items
                strongSelf.groupPickerTableViewCell.items = items.map { $0.title }

                var itemId = strongSelf.scheduleDataSource?.defaultGroupID()
                if let itemId = itemId, let value = strongSelf.valueById(items, itemId: itemId) {
                    strongSelf.groupPickerTableViewCell.selectRow(value)
                } else {
                    itemId = items.first?.id
                }
                strongSelf.scheduleDelegate?.didSelectGroup(itemId)
        }
    }

    // MARK: - Interface

    func selectedDepartment() -> DepartmentsEntity? {
        guard let selectedRow = departmentPickerTableViewCell.selectedRowIndex() else {
            return nil
        }
        return departments?[selectedRow]
    }

    func selectedFaculty() -> FacultiesEntity? {
        guard let selectedRow = facultyPickerTableViewCell.selectedRowIndex() else {
            return nil
        }
        return faculties?[selectedRow]
    }

    func selectedCourse() -> String? {
        let selectedRow = coursePickerTableViewCell.selectedRow()
        return selectedRow
    }

    func selectedGroup() -> GroupsEntity? {
        guard let selectedRow = groupPickerTableViewCell.selectedRowIndex() else {
            return nil
        }
        return groups?[selectedRow]
    }

    func selectedWeek() -> (startDate: Date, endDate: Date)? {
        guard
            let selectedRow = weekPickerTableViewCell.selectedRowIndex(),
            let week = weeks?[selectedRow] else {
                return nil
        }
        return (week.startDate, week.endDate)
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0

        if (indexPath.row % 2 == 0) {
            height = super.tableView(tableView, heightForRowAt: indexPath)
        } else if (selectedCell == indexPath.row) {
            height = 176
        }
        return height
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        selectedCell = (selectedCell != indexPath.row + 1) ? indexPath.row + 1 : -1

        if (selectedCell == 7) {
//            featchGroups()
        }

        tableView.beginUpdates()
        tableView.endUpdates()

        let scrollIndexPath = IndexPath(row: min(indexPath.row + 2, tableView.numberOfRows(inSection: indexPath.section) - 1), section: indexPath.section)
        tableView.scrollToRow(at: scrollIndexPath, at: .bottom, animated: true)
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }

    // MARK: - Utils

    func valueById(_ items: [AnyObject], itemId: String) -> String? {
        let item: AnyObject? = items.filter { $0.id == itemId }.first
        return item?.title
    }

    // MARK: - PickerTableViewCelldelegate

    func pickerTableViewCell(_ cell: PickerTableViewCell, didSelectRow row: Int, withText text: String) {

        switch cell {
        case departmentPickerTableViewCell:
            guard let departments = departments else { return }
            scheduleDelegate?.didSelectDepartment(departments[row].id)
            featchGroups(cachePolicy: .cachedElseLoad)
        case facultyPickerTableViewCell:
            guard let faculties = faculties else { return }
            scheduleDelegate?.didSelectFaculty(faculties[row].id)
            featchGroups(cachePolicy: .cachedElseLoad)
        case coursePickerTableViewCell:
            scheduleDelegate?.didSelectCourse(text)
            featchGroups(cachePolicy: .cachedElseLoad)
        case groupPickerTableViewCell:
            guard let groups = groups else { return }
            scheduleDelegate?.didSelectGroup(groups[row].id)
        case weekPickerTableViewCell:
            guard let weeks = weeks else { return }
            scheduleDelegate?.didSelectWeek(weeks[row].startDate)
        default: break
        }

    }
}

class ScheduleOptionsFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var _textLabel: UILabel!

    override var textLabel: UILabel? {
        return _textLabel
    }

}
