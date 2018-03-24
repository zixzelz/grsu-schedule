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
        
        tableView.register(UINib(nibName: "WeekSchedulesHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: SectionHeaderIdentifier)
        refreshControl!.addTarget(self, action: #selector(ListOfTeachersViewController.refresh(_:)), for: UIControlEvents.valueChanged)

        fetchData(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Flurry.logEvent("List Of Teachers")
    }

    func fetchData(_ useCache: Bool = true, animated: Bool) {
        
        if !refreshControl!.isRefreshing {
            setNeedShowRefreshControl()
        }
        
        let cache: CachePolicy = useCache ? .cachedElseLoad : .reloadIgnoringCache
        TeachersService().getTeachers(cache, completionHandler: { [weak self] result in

            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let items):
                strongSelf.searchDataSource.items = items
                strongSelf.teacherSections = strongSelf.prepareDataWithTeachers(items)
            case .failure(let error):
                strongSelf.teacherSections = [[TeacherInfoEntity]]()

                Flurry.logError(error, errId: "ListOfTeachersViewController")
//                strongSelf.showMessage("Ошибка при получении данных")
            }

            strongSelf.shouldShowRefreshControl = false
            strongSelf.refreshControl!.endRefreshing()
            strongSelf.tableView.reloadData()
        })
    }

    @objc func refresh(_ sender: AnyObject) {
        fetchData(false, animated: true)
    }

    func prepareDataWithTeachers(_ items: [TeacherInfoEntity]) -> [[TeacherInfoEntity]] {
        let theCollation = RYRussianIndexedCollation()

        let highSection = theCollation.sectionIndexTitles.count
        var sections = [[TeacherInfoEntity]](repeating: [TeacherInfoEntity](), count: highSection)

        for item in items {
            let sectionIndex = theCollation.sectionForObject(item.title)
            sections[sectionIndex].append(item)
        }
        return sections
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        var teacher: TeacherInfoEntity?
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            teacher = teacherSections![indexPath.section][indexPath.row]
        } else {
            if let indexPath = searchDataSource.searchDisplayController.searchResultsTableView.indexPath(for: cell) {
                teacher = searchDataSource.searcheArray![indexPath.row]
            }
        }

        if (segue.identifier == "TeacherInfoIdentifier") {
            let viewController = segue.destination as! TeacherInfoViewController
            viewController.teacherInfo = teacher

        } else if (segue.identifier == "SchedulePageIdentifier") {
            let weeks = DateManager.scheduleWeeks()

            let viewController = segue.destination as! TeacherSchedulesPageViewController
            viewController.dateScheduleQuery = DateScheduleQuery(startWeekDate: weeks.first!.startDate, endWeekDate: weeks.first!.endDate)
            viewController.possibleWeeks = weeks
            viewController.teacher = teacher
        }

    }
    
    func showMessage(_ title: String) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: - refresh Control
    
    fileprivate var shouldShowRefreshControl: Bool = false
    
    fileprivate func setNeedShowRefreshControl() {
        shouldShowRefreshControl = true
        showRefreshControlIfNeeded()
    }
    
    func showRefreshControlIfNeeded() {
        
        if !refreshControl!.isRefreshing {
            
            let dispatchTime: DispatchTime = DispatchTime.now() + 0.2
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: { [weak self] in
                guard let strongSelf = self,  strongSelf.shouldShowRefreshControl else { return }
                
                strongSelf.refreshControl!.beginRefreshing()
                strongSelf.scrollToTop()
            })
        }
    }
    
    func scrollToTop() {
        let top = self.tableView.contentInset.top
        self.tableView.contentOffset = CGPoint(x: 0, y: -top)
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {

        guard let sections = teacherSections else { return 0 }
        
        let count = sections.count > 0 ? sections.count : 1
        return count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = teacherSections, sections.count > 0 else { return 1 }

        let count = sections[section].count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell

        guard let sections = teacherSections, sections.count > 0 else {

            cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCellIdentifier")!
            return cell
        }

        let teacher = sections[indexPath.section][indexPath.row]

        cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCellIdentifier")!
        cell.textLabel?.text = teacher.title

        return cell
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return RYRussianIndexedCollation().sectionIndexTitles.map { "\($0)" }
    }

    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return RYRussianIndexedCollation().sectionForSectionIndexTitleAtIndex(index)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        guard let sections = teacherSections, sections.count > section && sections[section].count > 0 else {
            return nil
        }
        
        let char = RYRussianIndexedCollation().sectionIndexTitles[section]
        return "\(char)"
    }
}
