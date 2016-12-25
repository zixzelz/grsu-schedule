//
//  ListOfTeachersViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/10/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class ListOfTeachersViewController: UITableViewController {

    @IBOutlet weak var searchDataSource: ListOfTeachersSearchDataSource!
    var teacherSections: [[TeacherInfoEntity]]?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem?.title = "Back0"
        
        tableView.registerNib(UINib(nibName: "WeekSchedulesHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: SectionHeaderIdentifier)
        self.refreshControl!.addTarget(self, action: #selector(ListOfTeachersViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

        fetchData(animated: true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Flurry.logEvent("List Of Teachers")
    }

    func fetchData(useCache: Bool = true, animated: Bool) {
        
        if !refreshControl!.refreshing {
            setNeedShowRefreshControl()
        }
        
        let cache: CachePolicy = useCache ? .CachedElseLoad : .ReloadIgnoringCache
        TeachersService().getTeachers(cache, completionHandler: { [weak self] result in

            guard let strongSelf = self else { return }
            if case let .Success(items) = result {

                strongSelf.searchDataSource.items = items
                strongSelf.teacherSections = strongSelf.prepareDataWithTeachers(items)
            } else {

                strongSelf.teacherSections = [[TeacherInfoEntity]]()
            }

            strongSelf.shouldShowRefreshControl = false
            strongSelf.refreshControl!.endRefreshing()
            strongSelf.tableView.reloadData()
        })
    }

    func refresh(sender: AnyObject) {
        fetchData(false, animated: true)
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
    
    // MARK: - refresh Control
    
    private var shouldShowRefreshControl: Bool = false
    
    private func setNeedShowRefreshControl() {
        shouldShowRefreshControl = true
        showRefreshControlIfNeeded()
    }
    
    func showRefreshControlIfNeeded() {
        
        if !refreshControl!.refreshing {
            
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), { [weak self] _ in
                guard let strongSelf = self where  strongSelf.shouldShowRefreshControl else { return }
                
                strongSelf.refreshControl!.beginRefreshing()
                strongSelf.scrollToTop()
            })
        }
    }
    
    func scrollToTop() {
        let top = self.tableView.contentInset.top
        self.tableView.contentOffset = CGPointMake(0, -top)
    }

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        guard let sections = teacherSections else { return 0 }
        
        let count = sections.count > 0 ? sections.count : 1
        return count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = teacherSections where sections.count > 0 else { return 1 }

        let count = sections[section].count
        return count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: UITableViewCell

        guard let sections = teacherSections where sections.count > 0 else {

            cell = tableView.dequeueReusableCellWithIdentifier("EmptyCellIdentifier")!
            return cell
        }

        let teacher = sections[indexPath.section][indexPath.row]

        cell = tableView.dequeueReusableCellWithIdentifier("TeacherCellIdentifier")!
        cell.textLabel?.text = teacher.title

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
