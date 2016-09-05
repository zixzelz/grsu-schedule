//
//  ListOfTeachersViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/10/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class ListOfTeachersViewController: UITableViewController {

    @IBOutlet weak var searchDataSource: ListOfTeachersSearchDataSource!
    var teacherSections: [[TeacherInfoEntity]]?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "WeekSchedulesHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: SectionHeaderIdentifier)
        self.refreshControl!.addTarget(self, action: #selector(ListOfTeachersViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

        fetchData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Flurry.logEvent("List Of Teachers")
    }

    func scrollToTop() {
        let top = self.tableView.contentInset.top
        self.tableView.contentOffset = CGPointMake(0, -top)
    }

    func fetchData(useCache: Bool = true) {
        if (!self.refreshControl!.refreshing) {
            self.refreshControl!.beginRefreshing()
            scrollToTop()
        }
        GetTeachersService.getTeachers(useCache, completionHandler: { [weak self] result in

            guard let strongSelf = self else { return }
            if case let .Success(items) = result {

                strongSelf.searchDataSource.items = items
                strongSelf.teacherSections = strongSelf.prepareDataWithTeachers(items)
            } else {

                strongSelf.teacherSections = [[TeacherInfoEntity]]()
            }

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                strongSelf.refreshControl!.endRefreshing()
                strongSelf.tableView.reloadData()
            })
        })
    }

    func refresh(sender: AnyObject) {
        fetchData(false)
    }

    func prepareDataWithTeachers(items: [TeacherInfoEntity]) -> [[TeacherInfoEntity]] {
        let theCollation = RYRussianIndexedCollation()

        let highSection = theCollation.sectionIndexTitles.count
        var sections = [[TeacherInfoEntity]](count: highSection, repeatedValue: [TeacherInfoEntity]())

        for item in items {
            let sectionIndex = theCollation.sectionForObject(item.title)
            sections[sectionIndex].append(item)
        }
        return sections
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        var teacher: TeacherInfoEntity?
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPathForCell(cell) {
            teacher = teacherSections![indexPath.section][indexPath.row]
        } else {
            if let indexPath = searchDataSource.searchDisplayController.searchResultsTableView.indexPathForCell(cell) {
                teacher = searchDataSource.searcheArray![indexPath.row]
            }
        }

        if (segue.identifier == "TeacherInfoIdentifier") {
            let viewController = segue.destinationViewController as! TeacherInfoViewController
            viewController.teacherInfo = teacher

        } else if (segue.identifier == "SchedulePageIdentifier") {
            let weeks = DateManager.scheduleWeeks()

            let viewController = segue.destinationViewController as! TeacherSchedulesPageViewController
            viewController.dateScheduleQuery = DateScheduleQuery(startWeekDate: weeks.first!.startDate, endWeekDate: weeks.first!.endDate)
            viewController.possibleWeeks = weeks
            viewController.teacher = teacher
        }

    }

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var count = 1
        if (teacherSections == nil) {
            count = 0
        } else if (teacherSections!.count > 0) {
            count = teacherSections!.count
        }
        return count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if (teacherSections != nil && teacherSections?.count > 0) {
            count = teacherSections![section].count
        }
        return count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: UITableViewCell

        if (teacherSections != nil && teacherSections?.count == 0) {

            cell = tableView.dequeueReusableCellWithIdentifier("EmptyCellIdentifier")!
        } else {

            let teacher = teacherSections![indexPath.section][indexPath.row]

            cell = tableView.dequeueReusableCellWithIdentifier("TeacherCellIdentifier")!
            cell.textLabel?.text = teacher.title
        }

        return cell
    }

    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return RYRussianIndexedCollation().sectionIndexTitles.map { "\($0)" }
    }

    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return RYRussianIndexedCollation().sectionForSectionIndexTitleAtIndex(index)
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if (teacherSections?[section].count > 0) {

            let char = RYRussianIndexedCollation().sectionIndexTitles[section]
            return "\(char)"
        }
        return nil
    }
}
