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

    var dateScheduleQuery: DateScheduleQuery!
    var schedules: Array<DaySchedule>?

    var menuCellIndexPath: NSIndexPath?

    @IBOutlet var tableView: UITableView!
    var refreshControl: UIRefreshControl!

    func setLessonSchedule(lessons: [LessonScheduleEntity]) {
        var daySchedule = [DaySchedule]()

        for lesson in lessons {
            let days = daySchedule.filter { $0.date!.isEqualToDate(lesson.date) }
            var day = days.first

            if (day == nil) {
                day = DaySchedule()
                day?.date = lesson.date
                daySchedule.append(day!)
            }
            day?.lessons.append(lesson)
        }

        schedules = daySchedule
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "WeekSchedulesHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: SectionHeaderIdentifier)

        updatedTableViewInset()
        setupRefreshControl()
        fetchData(animated: true)
    }

    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(WeekSchedulesViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.tintColor = UIColor.blackColor()

        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    func updatedTableViewInset() {
        if let navigationBar = self.navigationController?.navigationBar {
            let top = CGRectGetMaxY(navigationBar.frame)
            let inset = UIEdgeInsetsMake(top, 0, 49, 0)
            self.tableView.contentInset = inset
            self.tableView.scrollIndicatorInsets = inset
        }
    }

    func reloadData(animated: Bool) {
        
        shouldShowRefreshControl = false
        let animated = animated && refreshControl.refreshing

        tableView.reloadData()
        refreshControl.endRefreshing()
        scrollToActiveLesson(animated)
    }
    
    func scrollToActiveLesson(animated: Bool) {
        let days = schedules?.filter { DateManager.daysBetweenDate($0.date, toDateTime: NSDate()) == 0 }
        let day = days?.first
        
        if let day = day {
            var startDate: NSDate?
            let calendar = NSCalendar.currentCalendar();
            
            calendar.rangeOfUnit(.Day, startDate: &startDate, interval: nil, forDate: NSDate())
            
            let minToday = Int(NSDate().timeIntervalSinceDate(startDate!) / 60)
            
            let lessons = day.lessons.filter { ($0.stopTime.integerValue >= minToday) }
            let lesson = lessons.first
            
            let dayIndex = schedules!.indexOf(day)!
            
            if let lesson = lesson {
                let indexPath = NSIndexPath(forRow: day.lessons.indexOf(lesson)!, inSection: dayIndex)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: animated)
            } else {
                let indexPath = NSIndexPath(forRow: 0, inSection: dayIndex)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: animated)
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.flashScrollIndicators()
        }
    }

    func refresh(sender: AnyObject) {
        fetchData(false, animated: true)
    }

    func fetchData(useCache: Bool = true, animated: Bool) {
        
        setNeedShowRefreshControl()
    }
    
    func scrollToTop() {
        let top = self.tableView.contentInset.top
        self.tableView.contentOffset = CGPointMake(0, -top)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "LessonLocationIdentifier") {
            let lesson = schedules![menuCellIndexPath!.section].lessons[menuCellIndexPath!.row - 1] as LessonScheduleEntity

            let viewController = segue.destinationViewController as! LessonLocationMapViewController
            viewController.initAddress = lesson.address
        }
    }
    
    // MARK: - refresh Control

    private var shouldShowRefreshControl: Bool = false
    
    private func setNeedShowRefreshControl() {
        shouldShowRefreshControl = true
        showRefreshControlIfNeeded()
    }
    
    func showRefreshControlIfNeeded() {
        
        if !refreshControl.refreshing {
            
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), { [weak self] _ in
                guard let strongSelf = self where  strongSelf.shouldShowRefreshControl else { return }
                
                strongSelf.refreshControl.beginRefreshing()
                strongSelf.scrollToTop()
            })
        }
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
            count = menuCellIndexPath?.section == section ? number + 1: number
        }
        return count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: UITableViewCell

        if (schedules == nil || schedules?.count == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("EmptyCellIdentifier")!

        } else if (indexPath.isEqual(menuCellIndexPath)) {
            cell = tableView.dequeueReusableCellWithIdentifier("MenuCellIdentifier")!

        } else {

            var fixIndexPath = indexPath
            if (menuCellIndexPath != nil && menuCellIndexPath?.section == indexPath.section && indexPath.row > menuCellIndexPath?.row) {
                fixIndexPath = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
            }

            let lesson = schedules![fixIndexPath.section].lessons[fixIndexPath.row] as LessonScheduleEntity

            let startLessonTime = lesson.date.dateByAddingTimeInterval(lesson.startTime.doubleValue * 60) as NSDate
            let endLessonTime = lesson.date.dateByAddingTimeInterval(lesson.stopTime.doubleValue * 60) as NSDate

            var lCell: BaseLessonScheduleCell
            if (NSDate().compare(startLessonTime) == NSComparisonResult.OrderedDescending && NSDate().compare(endLessonTime) == NSComparisonResult.OrderedAscending) {
                lCell = cellForLesson(lesson, isActive: true) as BaseLessonScheduleCell

                let acell = lCell as! ActiveLessonScheduleCell
                acell.lessonProgressView.progress = Float((NSDate().timeIntervalSinceDate(startLessonTime) / 60) / (lesson.stopTime.doubleValue - lesson.startTime.doubleValue))
            } else {
                lCell = cellForLesson(lesson, isActive: false)
            }

            if !NSString.isNilOrEmpty(lesson.address) || !NSString.isNilOrEmpty(lesson.room) {
                lCell.locationLabel.text = "\(lesson.address ?? ""); к.\(lesson.room ?? "")"
            } else {
                lCell.locationLabel.text = nil
            }
            lCell.studyTypeLabel.text = lesson.type
            lCell.studyNameLabel.text = lesson.studyName
            lCell.startTime = lesson.startTime.integerValue
            lCell.stopTime = lesson.stopTime.integerValue

            cell = lCell
        }

        return cell
    }

    func cellForLesson(lesson: LessonScheduleEntity, isActive: Bool) -> BaseLessonScheduleCell {
        return BaseLessonScheduleCell()
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SectionHeaderIdentifier)

        var title: String
        if (schedules == nil || schedules?.count == 0) {
            title = ""
        } else {
            let date = schedules![section].date
            title = DateUtils.formatDate(date, withFormat: DateFormatDayOfWeekAndMonthAndDay)
        }

        headerView?.textLabel?.text = title

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
        tableView.deselectRowAtIndexPath(indexPath, animated: false);

        var menuIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)

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
