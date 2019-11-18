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

    var menuCellIndexPath: IndexPath?

    @IBOutlet var tableView: UITableView!
    var refreshControl: UIRefreshControl!

    func setLessonSchedule(_ lessons: [LessonScheduleEntity]) {
        var daySchedule = [DaySchedule]()

        for lesson in lessons {
            let days = daySchedule.filter { ($0.date == lesson.date) }
            var day = days.first

            if (day == nil) {
                day = DaySchedule(date: lesson.date)
                daySchedule.append(day!)
            }
            day?.lessons.append(lesson)
        }

        schedules = daySchedule
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.delaysContentTouches = false

        tableView.register(UINib(nibName: "WeekSchedulesHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: SectionHeaderIdentifier)

        updatedTableViewInset()
        setupRefreshControl()
        fetchData(animated: true)
    }

    func showMessage(_ title: String) {

        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(WeekSchedulesViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.black

        tableView.refreshControl = refreshControl
    }

    private func updatedTableViewInset() {

//        if #available(iOS 11.0, *) {
//        } else {
            if let navigationBar = navigationController?.navigationBar {
                let top = navigationBar.bounds.height// + 20
                let inset = UIEdgeInsetsMake(top, 0, 49, 0)
                tableView.contentInset = inset
                tableView.scrollIndicatorInsets = inset
            }
//        }
    }

    func reloadData(_ animated: Bool) {

        shouldShowRefreshControl = false
        let animated = animated && refreshControl.isRefreshing

        tableView.reloadData()
        refreshControl.endRefreshing()
        scrollToActiveLesson(animated)
    }

    func scrollToActiveLesson(_ animated: Bool) {
        let days = schedules?.filter { DateManager.daysBetweenDate($0.date, toDateTime: Date()) == 0 }
        let day = days?.first

        if let day = day {
            var startDate: NSDate?
            let calendar = Calendar.shared

            (calendar as NSCalendar).range(of: .day, start: &startDate, interval: nil, for: Date())

            let minToday = Int(Date().timeIntervalSince(startDate! as Date) / 60)

            let lessons = day.lessons.filter { ($0.stopTime >= minToday) }
            let lesson = lessons.first

            let dayIndex = schedules!.index(of: day)!

            if let lesson = lesson {
                let indexPath = IndexPath(row: day.lessons.index(of: lesson)!, section: dayIndex)
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: animated)
            } else {
                let indexPath = IndexPath(row: 0, section: dayIndex)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
            }
        }

        DispatchQueue.main.async {
            self.tableView.flashScrollIndicators()
        }
    }

    @objc func refresh(_ sender: AnyObject) {
        fetchData(false, animated: true)
    }

    func fetchData(_ useCache: Bool = true, animated: Bool) {

        setNeedShowRefreshControl()
    }

    func scrollToTop() {
        let top = tableView.contentInset.top + 10
        tableView.contentOffset = CGPoint(x: 0, y: -top)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LessonLocationIdentifier", let schedules = schedules, let menuCellIndexPath = menuCellIndexPath {
            let lesson = schedules[menuCellIndexPath.section].lessons[menuCellIndexPath.row - 1]

            let viewController = segue.destination as! LessonLocationMapViewController
            viewController.initAddress = lesson.address
        }
    }

    // MARK: - refresh Control

    fileprivate var shouldShowRefreshControl: Bool = false

    fileprivate func setNeedShowRefreshControl() {
        shouldShowRefreshControl = true
        showRefreshControlIfNeeded()
    }

    func showRefreshControlIfNeeded() {

        if !refreshControl.isRefreshing {

            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: { [weak self] in
                guard let strongSelf = self, strongSelf.shouldShowRefreshControl else { return }

                strongSelf.refreshControl.beginRefreshing()
                strongSelf.scrollToTop()
            })
        }
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        if (schedules != nil && schedules?.count == 0) {
            return 1
        } else if (schedules == nil) {
            return 0
        }
        return schedules!.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if let schedules = schedules, schedules.count > 0 {
            let number = schedules[section].lessons.count
            count = menuCellIndexPath?.section == section ? number + 1 : number
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell

        guard let schedules = schedules else {
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCellIdentifier")!
        }

        if schedules.count == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCellIdentifier")!
            cell.textLabel?.text = L10n.scheduleListEmpty

        } else if indexPath == menuCellIndexPath {
            cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier")!

        } else {

            var fixIndexPath = indexPath
            if let menuCellIndexPath = menuCellIndexPath, menuCellIndexPath.section == indexPath.section && indexPath.row > menuCellIndexPath.row {
                fixIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            }

            let lesson = schedules[fixIndexPath.section].lessons[fixIndexPath.row]

            let startLessonTime = lesson.date.addingTimeInterval(TimeInterval(lesson.startTime * 60))
            let endLessonTime = lesson.date.addingTimeInterval(TimeInterval(lesson.stopTime * 60))

            var lCell: BaseLessonScheduleCell
            if Date() > startLessonTime && Date() < endLessonTime {
                lCell = cellForLesson(lesson, isActive: true)

                let acell = lCell as! ActiveLessonScheduleCell
                acell.lessonProgressView.progress = Float((Date().timeIntervalSince(startLessonTime) / 60) / Double(lesson.stopTime - lesson.startTime))
            } else {
                lCell = cellForLesson(lesson, isActive: false)
            }

            if !lesson.address.isNilOrEmpty || !lesson.room.isNilOrEmpty {
                lCell.locationLabel.text = "\(lesson.address ?? ""); \(L10n.roomNumberTitle)\(lesson.room ?? "")"
            } else {
                lCell.locationLabel.text = nil
            }
            lCell.studyTypeLabel.text = lesson.type
            lCell.studyNameLabel.text = lesson.studyName
            lCell.startTime = Int(lesson.startTime)
            lCell.stopTime = Int(lesson.stopTime)

            cell = lCell
        }

        return cell
    }

    func cellForLesson(_ lesson: LessonScheduleEntity, isActive: Bool) -> BaseLessonScheduleCell {
        return BaseLessonScheduleCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderIdentifier)

        var title: String
        if (schedules == nil || schedules?.count == 0) {
            title = ""
        } else {
            let date = schedules![section].date
            title = date.dayOfWeekAndMonthAndDayFormatter
        }

        headerView?.textLabel?.text = title

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath == menuCellIndexPath) ? 50 : 130
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        var menuIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)

        if (menuIndexPath == menuCellIndexPath) {
            menuCellIndexPath = nil
            tableView.deleteRows(at: [menuIndexPath], with: .middle)
        } else {
            tableView.beginUpdates()
            if let menuCellIndexPath = menuCellIndexPath {
                tableView.deleteRows(at: [menuCellIndexPath], with: .middle)

                if menuCellIndexPath.section == menuIndexPath.section && menuCellIndexPath.row < menuIndexPath.row {
                    menuIndexPath = indexPath
                }
            }
            tableView.insertRows(at: [menuIndexPath], with: .middle)
            menuCellIndexPath = menuIndexPath
            tableView.endUpdates()
        }
    }
}

class WeekSchedulesEmptyTableViewCell: UITableViewCell {

    @IBOutlet weak var _textLabel: UILabel!

    override var textLabel: UILabel? {
        return _textLabel
    }

}
