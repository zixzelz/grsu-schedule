//
//  SelectScheduleOptionsViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/11/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

protocol ScheduleOptionsTableViewControllerDelegate : NSObjectProtocol {
    
}

protocol ScheduleOptionsTableViewControllerDataSource : NSObjectProtocol {
    
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

//    var scheduleDelegate : ScheduleOptionsTableViewControllerDelegate?
//    var scheduleDataSource : ScheduleOptionsTableViewControllerDataSource?
    var selectedCell : NSInteger = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            self.setupPickerCells()
        }
    }
    
    func setupPickerCells() {
        featchData()
        
        let userDef = NSUserDefaults.standardUserDefaults()

        coursePickerTableViewCell.items = ["1", "2", "3", "4", "5", "6"]
        coursePickerTableViewCell.reloadData()
        if let item = userDef.objectForKey(NSUserDefaultsCourseCell) as? String {
            coursePickerTableViewCell.selectRow(item)
        }
        
        weekPickerTableViewCell.items = scheduleWeeks()
        weekPickerTableViewCell.reloadData()
        if let item = userDef.objectForKey(NSUserDefaultsWeekCell) as? String {
            weekPickerTableViewCell.selectRow(item)
        }
    }
    
    func featchData() {
        GetDepartmentsService.getDepartments { (items: NSArray?, error: NSError?) -> Void in
            self.departmentPickerTableViewCell.items = items
            self.departmentPickerTableViewCell.reloadData()
            let userDef = NSUserDefaults.standardUserDefaults()
            if let item = userDef.objectForKey(NSUserDefaultsDepartmentCell) as? String {
                self.departmentPickerTableViewCell.selectRow(item)
            }
        }
    }

    // pragma mark - Interface

    func selectedDepartment() -> Int {
        return departmentPickerTableViewCell.selectedRow()
    }
    
    func selectedFaculty() -> Int {
        return departmentPickerTableViewCell.selectedRow()
    }
    
    func selectedCourse() -> Int {
        return departmentPickerTableViewCell.selectedRow()
    }
    
    func selectedGroup() -> Int {
        return departmentPickerTableViewCell.selectedRow()
    }
    
    func selectedWeek() -> String {
        let week = departmentPickerTableViewCell.items
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
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // pragma mark - Utils
    
    func scheduleWeeks() -> NSArray! {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let formatterDate = NSDateFormatter()
        formatterDate.dateStyle = .ShortStyle
        
        var startOfTheWeek : NSDate?
        var endOfWeek : NSDate?
        var interval: NSTimeInterval = 0
        
        calendar.rangeOfUnit(NSCalendarUnit.WeekCalendarUnit, startDate: &startOfTheWeek, interval: &interval, forDate: date)
        
        let items = NSMutableArray()
        for (var i = 0; i < 4; i++) {
            let endOfWeek = startOfTheWeek?.dateByAddingTimeInterval(interval-1)
            
            let dateStartString = formatterDate.stringFromDate(startOfTheWeek!)
            let dateEndString = formatterDate.stringFromDate(endOfWeek!)
            let week = dateStartString + " - " + dateEndString
            
            items.addObject(week)
            startOfTheWeek = startOfTheWeek?.dateByAddingTimeInterval(interval)
        }
        return items
    }
    
    // pragma mark - PickerTableViewCelldelegate
    
    func pickerTableViewCell(cell: PickerTableViewCell, didSelectRow row: Int, withText text: String) {
        var key : String?
        
        switch cell {
        case departmentPickerTableViewCell : key = NSUserDefaultsDepartmentCell; break
        case facultyPickerTableViewCell : key = NSUserDefaultsFacultyCell; break
        case coursePickerTableViewCell : key = NSUserDefaultsCourseCell; break
        case groupPickerTableViewCell : key = NSUserDefaultsGroupCell; break
        case weekPickerTableViewCell : key = NSUserDefaultsWeekCell; break
        default : break
        }
        
        if key != nil {
            let userDef = NSUserDefaults.standardUserDefaults()
            userDef.setObject(text, forKey: key!)
        }

    }
}
