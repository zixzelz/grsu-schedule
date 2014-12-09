//
//  SelectScheduleOptionsViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/11/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

protocol ScheduleOptionsTableViewControllerDelegate : NSObjectProtocol {
    func didSelectDepartment(departmentId : String)
    func didSelectFaculty(facultyId : String)
    func didSelectCourse(course : String)
    func didSelectGroup(groupId : String?)
    func didSelectWeek(startDate : NSDate)
}

protocol ScheduleOptionsTableViewControllerDataSource : NSObjectProtocol {
    func defaultDepartmentID() -> String?
    func defaultFacultyID() -> String?
    func defaultCourse() -> String?
    func defaultGroupID() -> String?
    func defaultWeek() -> NSDate?
}

class ScheduleOptionsTableViewController: UITableViewController, PickerTableViewCellDelegate {

    @IBOutlet private weak var departmentTableViewCell : UITableViewCell!
    @IBOutlet private weak var facultyTableViewCell : UITableViewCell!
    @IBOutlet private weak var courseTableViewCell : UITableViewCell!
    @IBOutlet private weak var groupTableViewCell : UITableViewCell!
    @IBOutlet private weak var timeTableViewCell : UITableViewCell!

    @IBOutlet private weak var departmentPickerTableViewCell : PickerTableViewCell!
    @IBOutlet private weak var facultyPickerTableViewCell : PickerTableViewCell!
    @IBOutlet private weak var coursePickerTableViewCell : PickerTableViewCell!
    @IBOutlet private weak var groupPickerTableViewCell : PickerTableViewCell!
    @IBOutlet private weak var weekPickerTableViewCell : PickerTableViewCell!

    private var departments : Array<DepartmentsEntity>?
    private var faculties : Array<FacultiesEntity>?
    private var groups : Array<GroupsEntity>?
    private(set) var weeks : Array<GSWeekItem>!
    
    weak var scheduleDelegate : ScheduleOptionsTableViewControllerDelegate?
    weak var scheduleDataSource : ScheduleOptionsTableViewControllerDataSource?
    private var selectedCell : NSInteger = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            self.setupPickerCells()
        }
    }
    
    func setupPickerCells() {

        let courses = ["1", "2", "3", "4", "5", "6"]
        coursePickerTableViewCell.items = courses
        if let item = scheduleDataSource?.defaultCourse() {
            coursePickerTableViewCell.selectRow(item)
        } else {
            self.scheduleDelegate?.didSelectCourse(courses.first!);
        }
        
        weeks = WeekManager.scheduleWeeks()
        weekPickerTableViewCell.items = weeks!.map { $0.value }
        let startWeekDate = scheduleDataSource?.defaultWeek()
        
        let item = weeks.filter { $0.startDate == startWeekDate }.first

        if item != nil {
            weekPickerTableViewCell.selectRow(item!.value)
        } else {
            self.scheduleDelegate?.didSelectWeek(weeks.first!.startDate);
        }

        featchData()
    }
    
    func featchData() {        
        
        GetDepartmentsService.getDepartments { [weak self](array: Array<DepartmentsEntity>?, error: NSError?) -> Void in
            if let wSelf = self {
                if let items = array {
                    wSelf.departments = items
                    wSelf.departmentPickerTableViewCell.items = items.map { $0.title }
                    if let itemId = wSelf.scheduleDataSource?.defaultDepartmentID() {
                        if let value = wSelf.valueById(items, itemId: itemId) {
                            wSelf.departmentPickerTableViewCell.selectRow(value)
                        } else {
                            wSelf.scheduleDelegate?.didSelectDepartment(items.first!.id);
                        }
                        wSelf.featchGroups(fromCacheOnly: true);
                    }
                }
            }
        }
        GetFacultyService.getFaculties { [weak self](array: Array<FacultiesEntity>?, error: NSError?) -> Void in
            if let wSelf = self {
                if let items = array {
                    wSelf.faculties = items
                    wSelf.facultyPickerTableViewCell.items = items.map { $0.title }
                    if let itemId = wSelf.scheduleDataSource?.defaultFacultyID() {
                        if let value = wSelf.valueById(items, itemId: itemId) {
                            wSelf.facultyPickerTableViewCell.selectRow(value)
                        } else {
                            wSelf.scheduleDelegate?.didSelectFaculty(items.first!.id);
                        }
                        wSelf.featchGroups(fromCacheOnly: true);
                    }
                }
            }
        }
    }

    func featchGroups(fromCacheOnly : Bool = false) {
        let faculty = selectedFaculty()
        let departmant = selectedDepartment()
        let course = selectedCourse()
        
        if (faculty != nil && departmant != nil && course != nil) {
            GetGroupsService.getGroups(faculty!, department: departmant!, course: course!, completionHandler: { [weak self](array: Array<GroupsEntity>?, error: NSError?) -> Void in
                if let wSelf = self {
                    if let items = array {
                        wSelf.groups = items
                        wSelf.groupPickerTableViewCell.items = items.map { $0.title }
                        
                        var itemId = wSelf.scheduleDataSource?.defaultGroupID()
                        if let value = wSelf.valueById(items, itemId: itemId) {
                            wSelf.groupPickerTableViewCell.selectRow(value)
                        } else {
                            itemId = items.first?.id
                        }
                        wSelf.scheduleDelegate?.didSelectGroup(itemId);
                    }
                }
            })
        }
    }
    
    // pragma mark - Interface

    func selectedDepartment() -> DepartmentsEntity? {
        let selectedRow = departmentPickerTableViewCell.selectedRow() as Int?
        let item = (selectedRow != nil) ? departments?[selectedRow!] : nil
        return item
    }
    
    func selectedFaculty() -> FacultiesEntity? {
        let selectedRow = facultyPickerTableViewCell.selectedRow() as Int?
        let item = (selectedRow != nil) ? faculties?[selectedRow!] : nil
        return item
    }
    
    func selectedCourse() -> String? {
        let selectedRow = coursePickerTableViewCell.selectedRow() as String?
        return selectedRow
    }
    
    func selectedGroup() -> GroupsEntity? {
        let selectedRow = groupPickerTableViewCell.selectedRow() as Int?
        let item = (selectedRow != nil) ? groups?[selectedRow!] : nil
        return item
    }
    
    func selectedWeek() -> (startDate: NSDate, endDate: NSDate)? {
        let selectedRow = weekPickerTableViewCell.selectedRow() as Int?
        if (selectedRow != nil) {
            if let week = weeks?[selectedRow!] {
                return (week.startDate, week.endDate)
            }
        }
       return nil
    }
    
    // pragma mark - UITableViewDataSource

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height : CGFloat = 0
        
        if (indexPath.row % 2 == 0) {
            height = super.tableView(tableView, heightForRowAtIndexPath: indexPath);
        } else if (selectedCell == indexPath.row) {
            height = 176
        }
        return height
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 10
    }
    
    // pragma mark - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedCell = (selectedCell != indexPath.row + 1) ? indexPath.row + 1 : -1
        
        if (selectedCell == 7) {
            featchGroups()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        let scrollIndexPath = NSIndexPath(forRow: min(indexPath.row + 2, tableView.numberOfRowsInSection(indexPath.section)-1) , inSection: indexPath.section)
        tableView.scrollToRowAtIndexPath(scrollIndexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // pragma mark - Utils
        
    func valueById(items: [AnyObject], itemId: String?) -> String? {
        if let itemId_ = itemId {
            let item: AnyObject? = items.filter { $0.id == itemId_ }.first
            return item?.title
        }
        return nil
    }
    
    // pragma mark - PickerTableViewCelldelegate
    
    func pickerTableViewCell(cell: PickerTableViewCell, didSelectRow row: Int, withText text: String) {

        switch cell {
        case departmentPickerTableViewCell : scheduleDelegate?.didSelectDepartment(departments![row].id); featchGroups(fromCacheOnly: true); break
        case facultyPickerTableViewCell : scheduleDelegate?.didSelectFaculty(faculties![row].id); featchGroups(fromCacheOnly: true); break
        case coursePickerTableViewCell : scheduleDelegate?.didSelectCourse(text); featchGroups(fromCacheOnly: true); break
        case groupPickerTableViewCell : scheduleDelegate?.didSelectGroup(groups![row].id); break
        case weekPickerTableViewCell : scheduleDelegate?.didSelectWeek(weeks![row].startDate); break
        default : break
        }

    }
}
