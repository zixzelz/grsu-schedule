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
    func didSelectGroup(groupId : String)
    func didSelectWeek(weekId : String)
}

protocol ScheduleOptionsTableViewControllerDataSource : NSObjectProtocol {
    func defaultDepartmentID() -> String?
    func defaultFacultyID() -> String?
    func defaultCourse() -> String?
    func defaultGroupID() -> String?
    func defaultWeekID() -> String?
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

    private var departments : Array<GSItem>?
    private var faculties : Array<GSItem>?
    private var groups : Array<GSItem>?
    private(set) var weeks : Array<GSItem>?
    
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
        featchData()

        coursePickerTableViewCell.items = ["1", "2", "3", "4", "5", "6"]
        coursePickerTableViewCell.reloadData()
        if let item = scheduleDataSource?.defaultCourse() {
            coursePickerTableViewCell.selectRow(item)
        }
        
        weeks = scheduleWeeks()
        weekPickerTableViewCell.items = weeks!.map { $1 }
        weekPickerTableViewCell.reloadData()
        if let itemId = scheduleDataSource?.defaultWeekID() {
            let item = weeks!.filter { $0.id == itemId }.first
            if let value = item?.value {
                weekPickerTableViewCell.selectRow(value)
            }
        }
    }
    
    func featchData() {
        GetDepartmentsService.getDepartments { [weak self](array: Array<GSItem>?, error: NSError?) -> Void in
            if let wSelf = self {
                if let items = array {
                    wSelf.departments = items
                    wSelf.departmentPickerTableViewCell.items = items.map { $1 }
                    wSelf.departmentPickerTableViewCell.reloadData()
                    if let itemId = wSelf.scheduleDataSource?.defaultDepartmentID() {
                        let item = items.filter { $0.id == itemId }.first
                        if let value = item?.value {
                            wSelf.departmentPickerTableViewCell.selectRow(value)
                        }
                    }
                }
            }
        }
        GetFacultyService.getFaculties { [weak self](array: Array<GSItem>?, error: NSError?) -> Void in
            if let wSelf = self {
                if let items = array {
                    wSelf.faculties = items
                    wSelf.facultyPickerTableViewCell.items = items.map { $1 }
                    wSelf.facultyPickerTableViewCell.reloadData()
                    if let itemId = wSelf.scheduleDataSource?.defaultFacultyID() {
                        let item = items.filter { $0.id == itemId }.first
                        if let value = item?.value {
                            wSelf.facultyPickerTableViewCell.selectRow(value)
                        }
                    }
                }
            }
        }
    }

    func featchGroups(fromCacheOnly : Bool = false) {
        let facultyId = selectedFacultyId()
        let departmantId = selectedDepartmentId()
        let course = selectedCourse()
        
        if (facultyId != nil && departmantId != nil && course != nil) {
            GetGroupsService.getGroups(facultyId!, departmantId: departmantId!, course: course!, completionHandler: { [weak self](array: Array<GSItem>?, error: NSError?) -> Void in
                if let wSelf = self {
                    if let items = array {
                        wSelf.groups = items
                        wSelf.groupPickerTableViewCell.items = items.map { $1 }
                        wSelf.groupPickerTableViewCell.reloadData()
                        if let itemId = wSelf.scheduleDataSource?.defaultGroupID() {
                            let item = items.filter { $0.id == itemId }.first
                            if let value = item?.value {
                                wSelf.groupPickerTableViewCell.selectRow(value)
                            }
                        }
                    }
                }
            })
        }
    }
    
    // pragma mark - Interface

    func selectedDepartmentId() -> String? {
        let selectedRow = departmentPickerTableViewCell.selectedRow() as Int
        let item = departments?[selectedRow] as GSItem?
        return item?.id
    }
    
    func selectedFacultyId() -> String? {
        let selectedRow = facultyPickerTableViewCell.selectedRow() as Int
        let item = faculties?[selectedRow] as GSItem?
        return item?.id
    }
    
    func selectedCourse() -> String? {
        let selectedRow = coursePickerTableViewCell.selectedRow() as String?
        return selectedRow
    }
    
    func selectedGroupId() -> String? {
        let selectedRow = groupPickerTableViewCell.selectedRow() as Int
        let item = groups?[selectedRow] as GSItem?
        return item?.id
    }
    
    func selectedWeek() -> String? {
        let week = weekPickerTableViewCell.items
        return departmentPickerTableViewCell.selectedRow()
    }
    
    // pragma mark - UITableViewDataSource

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height : CGFloat = 0
        
        if (indexPath.row % 2 == 0) {
            height = super.tableView(tableView, heightForRowAtIndexPath: indexPath);
        } else if (selectedCell == indexPath.row) {
            height = 216
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
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // pragma mark - Utils
    
    func scheduleWeeks() -> Array<GSItem>! {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let formatterDate = NSDateFormatter()
        formatterDate.dateStyle = .ShortStyle
        
        var startOfTheWeek : NSDate?
        var endOfWeek : NSDate?
        var interval: NSTimeInterval = 0
        
        calendar.rangeOfUnit(NSCalendarUnit.WeekCalendarUnit, startDate: &startOfTheWeek, interval: &interval, forDate: date)
        
        var items  = Array<GSItem>()
        for (var i = 0; i < 4; i++) {
            let endOfWeek = startOfTheWeek?.dateByAddingTimeInterval(interval-1)
            
            let dateStartString = formatterDate.stringFromDate(startOfTheWeek!)
            let dateEndString = formatterDate.stringFromDate(endOfWeek!)
            
            let value = dateStartString + " - " + dateEndString
            let gsItem = GSItem(dateStartString, value)
            
            items.append(gsItem)
            startOfTheWeek = startOfTheWeek?.dateByAddingTimeInterval(interval)
        }
        return items
    }
    
    // pragma mark - PickerTableViewCelldelegate
    
    func pickerTableViewCell(cell: PickerTableViewCell, didSelectRow row: Int, withText text: String) {
        
        switch cell {
        case departmentPickerTableViewCell : scheduleDelegate?.didSelectDepartment(departments![row].id); featchGroups(fromCacheOnly: false); break
        case facultyPickerTableViewCell : scheduleDelegate?.didSelectFaculty(faculties![row].id); featchGroups(fromCacheOnly: false); break
        case coursePickerTableViewCell : scheduleDelegate?.didSelectCourse(text); featchGroups(fromCacheOnly: false); break
        case groupPickerTableViewCell : scheduleDelegate?.didSelectGroup(groups![row].id); break
        case weekPickerTableViewCell : scheduleDelegate?.didSelectWeek(weeks![row].id); break
        default : break
        }

    }
}
