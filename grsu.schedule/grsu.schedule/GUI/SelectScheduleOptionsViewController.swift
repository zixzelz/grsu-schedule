//
//  SelectScheduleOptionsViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/11/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class SelectScheduleOptionsViewController: UITableViewController {

    @IBOutlet weak var departmentTableViewCell : UITableViewCell!
    @IBOutlet weak var facultyTableViewCell : UITableViewCell!
    @IBOutlet weak var courseTableViewCell : UITableViewCell!
    @IBOutlet weak var groupTableViewCell : UITableViewCell!
    @IBOutlet weak var timeTableViewCell : UITableViewCell!

    @IBOutlet weak var departmentPickerTableViewCell : PickerTableViewCell!
    @IBOutlet weak var facultyPickerTableViewCell : PickerTableViewCell!
    @IBOutlet weak var coursePickerTableViewCell : PickerTableViewCell!
    @IBOutlet weak var groupPickerTableViewCell : PickerTableViewCell!
    @IBOutlet weak var timePickerTableViewCell : PickerTableViewCell!

    var selectedCell : NSInteger = -1
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            self.setupPickerCells()
        }
    }
    
    func setupPickerCells() {
        featchData()
        
        coursePickerTableViewCell.items = ["1", "2", "3", "4", "5", "6"]
        coursePickerTableViewCell.reloadData()
        timePickerTableViewCell.items = scheduleWeeks()
        timePickerTableViewCell.reloadData()
    }
    
    func featchData() {
        GetDepartmentsService.getDepartments { (items: NSArray?, error: NSError?) -> Void in
            self.departmentPickerTableViewCell.items = items
            self.departmentPickerTableViewCell.reloadData()
        }
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
    
}
