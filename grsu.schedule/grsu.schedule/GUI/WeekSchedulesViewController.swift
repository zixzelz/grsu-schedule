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
    var refreshControl:UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "WeekSchedulesHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: SectionHeaderIdentifier)
        
        self.updatedTableViewInset()
        setupRefreshControl()
        fetchData()
    }
    
    func setupRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func updatedTableViewInset() {
        if let navigationBar = self.navigationController?.navigationBar {
            let top = CGRectGetMaxY(navigationBar.frame)
            let inset = UIEdgeInsetsMake(top, 0, 0, 0)
            self.tableView.contentInset = inset
            self.tableView.scrollIndicatorInsets = inset
        }
        scrollToTop()
    }
    
    func scrollToTop() {
        let top = self.tableView.contentInset.top
        self.tableView.contentOffset = CGPointMake(0, -top)
    }
    
    func scrollToActiveLesson() {
        let days = schedules?.filter { DateManager.daysBetweenDate($0.date, toDateTime: NSDate()) == 0 }
        let day = days?.first
        
        if let day = day {
            var startDate: NSDate?
            let calendar = NSCalendar.currentCalendar();
            calendar.rangeOfUnit(.CalendarUnitDay, startDate: &startDate, interval: nil, forDate: NSDate())
            
            let minToday = Int(NSDate().timeIntervalSinceDate(startDate!) / 60)
            
            var lessons = day.lessons.array as [LessonScheduleEntity]
            
            lessons = lessons.filter { ($0.stopTime.integerValue >= minToday) }
            let lesson = lessons.first
            
            if let lesson = lesson {
                let indexPath = NSIndexPath(forRow: day.lessons.indexOfObject(lesson), inSection: find(schedules!, day)!)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: false)
            } else {
                let indexPath = NSIndexPath(forRow: 0, inSection: find(schedules!, day)!)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
            }
        }
    }
    
    func fetchData(useCache: Bool = true) {
        if (!self.refreshControl.refreshing) {
            self.refreshControl.beginRefreshing()
            scrollToTop()
        }
        
        GetStudentScheduleService.getSchedule(scheduleQuery!.group!, dateStart: scheduleQuery!.startWeekDate!, dateEnd: scheduleQuery!.endWeekDate!, useCache: useCache) { [weak self] (items: Array<StudentDayScheduleEntity>?, error: NSError?) -> Void in
            if let wSelf = self {
                wSelf.refreshControl.endRefreshing()
                wSelf.schedules = items
                wSelf.tableView.reloadData()
                wSelf.scrollToActiveLesson()
            }
        }
    }
    
    func refresh(sender:AnyObject) {
        fetchData(useCache: false)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (schedules != nil && schedules?.count == 0) {
            return 1
        } else if (schedules == nil) {
            return 0
        }
        return schedules!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if (schedules != nil && schedules?.count > 0) {
            let number = schedules![section].lessons.count
            count = menuCellIndexPath?.section == section ? number+1 : number
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell

        if (schedules == nil || schedules?.count == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("EmptyCellIdentifier") as UITableViewCell
            
        } else if (indexPath.isEqual(menuCellIndexPath)) {
            cell = tableView.dequeueReusableCellWithIdentifier("MenuCellIdentifier") as UITableViewCell
            
        } else {
            
            var fixIndexPath = indexPath
            if (menuCellIndexPath != nil && menuCellIndexPath?.section == indexPath.section && indexPath.row > menuCellIndexPath?.row) {
                fixIndexPath = NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)
            }
            
            var lesson = schedules![fixIndexPath.section].lessons[fixIndexPath.row] as LessonScheduleEntity
            
            var identifier : String
            
            let startLessonTime = lesson.studentDaySchedule.date.dateByAddingTimeInterval(lesson.startTime.doubleValue * 60) as NSDate
            let endLessonTime = lesson.studentDaySchedule.date.dateByAddingTimeInterval(lesson.stopTime.doubleValue * 60) as NSDate
            
            var lCell: LessonScheduleCell
            if (NSDate().compare(startLessonTime) == NSComparisonResult.OrderedDescending && NSDate().compare(endLessonTime) == NSComparisonResult.OrderedAscending) {
                identifier = "ActiveLessonCellIdentifier"
                let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as ActiveLessonScheduleCell
                cell.lessonProgressView.progress = Float(( NSDate().timeIntervalSinceDate(startLessonTime) / 60 ) / (lesson.stopTime.doubleValue - lesson.startTime.doubleValue))
                
                lCell = cell
            } else {
                identifier = "LessonCellIdentifier"
                lCell = tableView.dequeueReusableCellWithIdentifier(identifier) as LessonScheduleCell
            }
            
            lCell.locationLabel.text = NSString(format: "%@; к.%@", lesson.address, lesson.room )
            lCell.subgroupTitleLabel.text = !NSString.isNilOrEmpty(lesson.subgroupTitle) ? NSString(format: "Подгруппа: %@", lesson.subgroupTitle! ) : ""
            lCell.studyTypeLabel.text = lesson.type
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

        var title: String
        if (schedules == nil || schedules?.count == 0) {
            title = ""
        } else {
            let date = schedules![section].date
            title = DateUtils.formatDate(date, withFormat: DateFormatDayOfWeekAndMonthAndDay)
        }
        
        headerView.textLabel.text = title
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.isEqual(menuCellIndexPath) ? 50 : 130
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    // MARK: - UITableViewDelegate
    
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
