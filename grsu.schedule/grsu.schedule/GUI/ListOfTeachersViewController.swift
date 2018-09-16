//
//  ListOfTeachersViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/10/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import ReactiveSwift
//import ReactiveCocoa

// TODO: Make with MVVM
class ListOfTeachersViewController: UITableViewController {

    var originalTeachers: [TeacherInfoEntity]?
    var teacherSections: [[TeacherInfoEntity]] = []

    lazy var searchController: CustomSearchController = {
        return CustomSearchController(searchResultsController: resultsTableController)
    }()

    lazy var resultsTableController: ListOfTeachersResultController = {
        let vc = ListOfTeachersResultController()
        vc.paretViewController = self
        return vc
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.tabBarItem?.setLocalizedTitle(L10n.teachersTabbarTitle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "WeekSchedulesHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: SectionHeaderIdentifier)
        refreshControl?.addTarget(self, action: #selector(ListOfTeachersViewController.refresh(_:)), for: UIControlEvents.valueChanged)

        setupSearchController()
        fetchData(animated: true)

        navigationItem.setLocalizedTitle(L10n.teachersNavigationBarTitle)
        navigationController?.title = L10n.teachersNavigationBarTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(localizedTitle: L10n.backBarButtonItemTitle, style: .plain, target: nil, action: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Flurry.logEvent("List Of Teachers")
    }

    private func setupSearchController() {

        searchController.searchResultsUpdater = resultsTableController
        searchController.searchBar.setLocalizedPlaceholder(L10n.searchBarPlaceholderTitle)

//        if #available(iOS 9.1, *) {
//            searchController.obscuresBackgroundDuringPresentation = false
//        }

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }

        definesPresentationContext = true

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor.navigationBar
        }

        // Fix bug with a magic line between navigationBar and searchBar 🤬
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.subviews.first?.clipsToBounds = true
        }
    }

    private func fetchData(_ useCache: Bool = true, animated: Bool) {

        if let refreshControl = refreshControl, !refreshControl.isRefreshing {
            setNeedShowRefreshControl()
        }

        let cache: CachePolicy = useCache ? .cachedElseLoad : .reloadIgnoringCache
        TeachersService().getTeachers(cache, completionHandler: { [weak self] result in

            guard let strongSelf = self else { return }

            switch result {
            case .success(let items):
                strongSelf.resultsTableController.items = items
                strongSelf.teacherSections = strongSelf.prepareDataWithTeachers(items)
            case .failure(let error):
                strongSelf.teacherSections = [[TeacherInfoEntity]]()
                Flurry.logError(error, errId: "ListOfTeachersViewController")
            }

            strongSelf.shouldShowRefreshControl = false
            strongSelf.refreshControl?.endRefreshing()
            strongSelf.tableView.reloadData()
        })
    }

    @objc func refresh(_ sender: AnyObject) {
        fetchData(false, animated: true)
    }

    private func prepareDataWithTeachers(_ items: [TeacherInfoEntity]) -> [[TeacherInfoEntity]] {
        let theCollation = RYRussianIndexedCollation()

        let highSection = theCollation.sectionIndexTitles.count
        var sections = [[TeacherInfoEntity]](repeating: [TeacherInfoEntity](), count: highSection)

        for item in items {
            let sectionIndex = theCollation.sectionForObject(item.displayTitle)
            sections[sectionIndex].append(item)
        }
        return sections
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        var teacher: TeacherInfoEntity?
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            teacher = teacherSections[indexPath.section][indexPath.row]
        } else {
            if let indexPath = resultsTableController.tableView.indexPath(for: cell) {
                teacher = resultsTableController.filteredItems?[indexPath.row]
            }
        }

        if (segue.identifier == "TeacherInfoIdentifier") {
            if let nc = segue.destination as? UINavigationController,
                let viewController = nc.topViewController as? TeacherInfoViewController {

                viewController.teacherInfo = teacher
            }

        } else if (segue.identifier == "SchedulePageIdentifier") {

            if let nc = segue.destination as? UINavigationController,
                let viewController = nc.topViewController as? TeacherSchedulesPageViewController {

                let weeks = DateManager.scheduleWeeks()
                viewController.dateScheduleQuery = DateScheduleQuery(startWeekDate: weeks[0].startDate, endWeekDate: weeks[0].endDate)
                viewController.possibleWeeks = weeks
                viewController.teacher = teacher
            }
        }

    }

    private func showMessage(_ title: String) {

        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    // MARK: - refresh Control

    private var shouldShowRefreshControl: Bool = false

    private func setNeedShowRefreshControl() {
        shouldShowRefreshControl = true
        showRefreshControlIfNeeded()
    }

    private func showRefreshControlIfNeeded() {

        if let refreshControl = refreshControl, !refreshControl.isRefreshing {

            let dispatchTime: DispatchTime = DispatchTime.now() + 0.2
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: { [weak self] in
                guard let strongSelf = self, strongSelf.shouldShowRefreshControl else { return }

                strongSelf.refreshControl?.beginRefreshing()
                strongSelf.scrollToTop()
            })
        }
    }

    private func scrollToTop() {
        let top = self.tableView.contentInset.top
        self.tableView.contentOffset = CGPoint(x: 0, y: -top)
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        let count = teacherSections.count > 0 ? teacherSections.count : 1
        return count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard teacherSections.count > 0 else { return 1 }

        let count = teacherSections[section].count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell

        let items = teacherSections.count > indexPath.section ? teacherSections[indexPath.section] : []

        guard items.count > 0 else {
            cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCellIdentifier")!
            cell.textLabel?.setLocalizedTitle(L10n.teachersListEmpty)
            return cell
        }

        let teacher = items[indexPath.row]

        cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCellIdentifier")!
        cell.textLabel?.text = teacher.displayTitle

        return cell
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return RYRussianIndexedCollation().sectionIndexTitles.map { "\($0)" }
    }

    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return RYRussianIndexedCollation().sectionForSectionIndexTitleAtIndex(index)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        guard teacherSections.count > section && teacherSections[section].count > 0 else {
            return nil
        }

        let char = RYRussianIndexedCollation().sectionIndexTitles[section]
        return "\(char)"
    }
}
