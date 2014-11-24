//
//  WeekSchedulesViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class WeekSchedulesViewController: UIViewController, UITableViewDataSource {

    var scheduleQuery : StudentScheduleQuery?
    var schedules: Array<StudentDaySchedule>?
    
    @IBOutlet private var tableView : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        GetStudentScheduleService.getSchedule(scheduleQuery!.groupId!, week: scheduleQuery!.week!, completionHandler: { [weak self](array: Array<StudentDaySchedule>?, error: NSError?) -> Void in
            if let wSelf = self {
                wSelf.schedules = array
                wSelf.tableView.reloadData()
            }
        })
    }
    
    // pragma mark - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return schedules?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules![section].lessons?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var lesson = schedules![indexPath.section].lessons![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LessonCellIdentifier") as LessonScheduleCell
        cell.locationLabel.text = lesson.location
        cell.studyNameLabel.text = lesson.studyName
        cell.teacherLabel.text = lesson.teacher
        cell.startTime = lesson.startTime
        cell.stopTime = lesson.stopTime
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = schedules![section].date!
        return DateUtils.formatDate(date, withFormat: DateFormatDayOfWeekAndMonthAndDay)
    }
    
}
