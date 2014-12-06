//
//  WeekSchedulesViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

let SectionHeaderIdentifier = "SectionHeaderIdentifier"

class WeekSchedulesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var scheduleQuery : StudentScheduleQuery?
    var schedules: Array<StudentDayScheduleEntity>?
    
    var menuCellIndexPath: NSIndexPath?
    
    @IBOutlet private var tableView : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "WeekSchedulesHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: SectionHeaderIdentifier)
        
        fetchData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updatedTableViewInset()
    }

    func updatedTableViewInset() {
        if let navigationBar = self.navigationController?.navigationBar {
            let top = CGRectGetMaxY(navigationBar.frame)
            let inset = UIEdgeInsetsMake(top, 0, 0, 0)
            self.tableView.contentInset = inset
            self.tableView.scrollIndicatorInsets = inset
            self.tableView.contentOffset = CGPointMake(0, -top)
        }
    }
    
    func fetchData() {
        GetStudentScheduleService.getSchedule(scheduleQuery!.group!, dateStart: scheduleQuery!.startWeekDate!, dateEnd: scheduleQuery!.endWeekDate!) { [weak self] (items: Array<StudentDayScheduleEntity>?, error: NSError?) -> Void in
            if let wSelf = self {
                wSelf.schedules = items
                wSelf.tableView.reloadData()
            }
        }
    }
    
    // pragma mark - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return schedules?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = schedules![section].lessons.count
        return menuCellIndexPath?.section == section ? number+1 : number
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell

        if (indexPath.isEqual(menuCellIndexPath)) {
            cell = tableView.dequeueReusableCellWithIdentifier("MenuCellIdentifier") as UITableViewCell
            
        } else {
            
            var fixIndexPath = indexPath
            if (menuCellIndexPath != nil && menuCellIndexPath?.section == indexPath.section && indexPath.row > menuCellIndexPath?.row) {
                fixIndexPath = NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)
            }
            
            var lesson = schedules![fixIndexPath.section].lessons[fixIndexPath.row] as LessonScheduleEntity
            
            var identifier : String
            if (indexPath.row == 0) {
                identifier = "ActiveLessonCellIdentifier"
            } else {
                identifier = "LessonCellIdentifier"
            }
            let lCell = tableView.dequeueReusableCellWithIdentifier(identifier) as LessonScheduleCell
            
            lCell.locationLabel.text = lesson.address
            lCell.studyNameLabel.text = lesson.studyName
            lCell.teacherLabel.text = lesson.teacher.title
            lCell.startTime = lesson.startTime.integerValue
            lCell.stopTime = lesson.stopTime.integerValue
            
            cell = lCell
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SectionHeaderIdentifier) as UITableViewHeaderFooterView
        let date = schedules![section].date

        headerView.textLabel.text = DateUtils.formatDate(date, withFormat: DateFormatDayOfWeekAndMonthAndDay)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.isEqual(menuCellIndexPath) ? 50 : 130
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    // pragma mark - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var menuIndexPath = NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)
        
        if (menuIndexPath.isEqual(menuCellIndexPath)) {
            menuCellIndexPath = nil
            tableView.deleteRowsAtIndexPaths([menuIndexPath], withRowAnimation: .Middle)
        } else {
            tableView.beginUpdates()
            if (menuCellIndexPath != nil) {
                tableView.deleteRowsAtIndexPaths([menuCellIndexPath!], withRowAnimation: .Middle)
                
                if (menuCellIndexPath?.section == menuIndexPath.section && menuCellIndexPath?.row < menuIndexPath.row) {
                    menuIndexPath = indexPath
                }
            }
            tableView.insertRowsAtIndexPaths([menuIndexPath], withRowAnimation: .Middle)
            menuCellIndexPath = menuIndexPath
            tableView.endUpdates()
        }
    }
}
