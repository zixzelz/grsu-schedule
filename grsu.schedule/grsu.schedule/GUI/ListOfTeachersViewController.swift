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
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
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
        GetTeachersService.getTeachers(useCache, completionHandler: { [weak self](items: Array<TeacherInfoEntity>?, error: NSError?) -> Void in
            if let wSelf = self {
                wSelf.searchDataSource.items = items
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    
                    if let items = items {
                        wSelf.teacherSections = wSelf.prepareDataWithTeachers(items)
                    } else {
                        wSelf.teacherSections = [[TeacherInfoEntity]]()
                    }

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        wSelf.refreshControl!.endRefreshing()
                        wSelf.tableView.reloadData()
                    })
                })// dispatch_async
            }
        })
    }
    
    func refresh(sender:AnyObject) {
        fetchData(useCache: false)
    }
    
    func prepareDataWithTeachers(items: Array<TeacherInfoEntity>) -> [[TeacherInfoEntity]] {
        let theCollation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation
        
        let highSection = theCollation.sectionIndexTitles.count
        var sections = [[TeacherInfoEntity]](count: highSection, repeatedValue: [TeacherInfoEntity]())
        
        for item in items {
            let sectionIndex = theCollation.sectionForObject(item, collationStringSelector: "title")
            sections[sectionIndex].append(item)
        }
        return sections
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var teacher: TeacherInfoEntity?
        let cell = sender as UITableViewCell!
        if let indexPath = tableView.indexPathForCell(cell) {
            teacher = teacherSections![indexPath.section][indexPath.row]
        } else {
            if let indexPath = searchDataSource.searchDisplayController.searchResultsTableView.indexPathForCell(cell) {
                teacher = searchDataSource.searcheArray![indexPath.row]
            }
        }

        
        if (segue.identifier == "TeacherInfoIdentifier") {
            let viewController = segue.destinationViewController as TeacherInfoViewController
            viewController.teacherInfo = teacher
            
        } else if (segue.identifier == "SchedulePageIdentifier") {
            let weeks = DateManager.scheduleWeeks()
            
            let viewController = segue.destinationViewController as TeacherSchedulesPageViewController
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
        
        var cell : UITableViewCell
        
        if (teacherSections != nil && teacherSections?.count == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("EmptyCellIdentifier") as UITableViewCell
        } else {
            
            var teacher = teacherSections![indexPath.section][indexPath.row]

            cell = tableView.dequeueReusableCellWithIdentifier("TeacherCellIdentifier") as UITableViewCell
            cell.textLabel?.text = teacher.title
        }
        
        return cell
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return UILocalizedIndexedCollation.currentCollation().sectionIndexTitles
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (teacherSections?[section].count > 0) {
            return UILocalizedIndexedCollation.currentCollation().sectionIndexTitles[section] as? String
        }
        return nil
    }
}
