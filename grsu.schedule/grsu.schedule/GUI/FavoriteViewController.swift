//
//  FavoriteViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/9/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

class FavoriteViewController: UITableViewController {

    @IBOutlet weak var editButton: UIButton!

    var favorites: [FavoriteEntity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        applyLargeTitles()
    }

    private func applyLargeTitles() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchFavorite()
    }

    func fetchFavorite() {
        let manager = FavoriteManager()

        manager.getAllFavorite { [weak self](items: [FavoriteEntity]) -> Void in
            if let wSelf = self {
                wSelf.favorites = items
                wSelf.tableView.reloadData()
                wSelf.updateState()
            }
        }

    }

    @IBAction func editButtonPressed(_ sender: UIButton) {

        if (tableView.isEditing) {
            updateFavoriteOrder()
        }

        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.isSelected = tableView.isEditing
    }

    func updateFavoriteOrder() {
        for i in 0..<favorites.count {
            favorites[i].order = NSNumber(value: i)
        }
        CoreDataHelper.saveContext(CoreDataHelper.managedObjectContext)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "StudentFavoriteSegueIdentifier" || segue.identifier == "TeacherFavoriteSegueIdentifier") {

            if let indexPath = tableView.indexPathForSelectedRow {

                let item = favorites[indexPath.row]
                let week = DateManager.scheduleWeeks()

                let scheduleQuery = DateScheduleQuery()
                scheduleQuery.startWeekDate = week.first?.startDate
                scheduleQuery.endWeekDate = week.first?.endDate

                if (segue.identifier == "StudentFavoriteSegueIdentifier") {
                    guard let group = item.group else { return }

                    if let nc = segue.destination as? UINavigationController,
                        let viewController = nc.topViewController as? StudentSchedulesPageViewController {

                        viewController.possibleWeeks = week
                        viewController.dateScheduleQuery = scheduleQuery
                        viewController.configure(group)
                    }
                }
                if (segue.identifier == "TeacherFavoriteSegueIdentifier") {

                    if let nc = segue.destination as? UINavigationController,
                        let viewController = nc.topViewController as? TeacherSchedulesPageViewController {

                        viewController.possibleWeeks = week
                        viewController.dateScheduleQuery = scheduleQuery
                        viewController.teacher = item.teacher
                    }
                }
            }
        }

    }

    func updateState() {
        editButton.isHidden = favorites.count <= 0
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return favoriteCell(indexPath.row)
    }

    func favoriteCell(_ row: Int) -> UITableViewCell {
        var cell: UITableViewCell?

        if let group = favorites[row].group {

            cell = tableView.dequeueReusableCell(withIdentifier: "StudentFavoriteCellIdentifier")
            cell!.textLabel?.text = group.title

        } else if let teacher = favorites[row].teacher {

            cell = tableView.dequeueReusableCell(withIdentifier: "TeacherFavoriteCellIdentifier")

            var text = teacher.displayTitle

            let texts = text.components(separatedBy: " ")
            if texts.count > 2 {

                let first = String(texts[0][0]).capitalized
                let second = String(texts[2][0]).capitalized

                text = texts[1] + " \(first). \(second)."
            }

            cell!.textLabel?.text = text
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        }

        return cell!
    }
//
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        var title: String?
//        switch (section) {
//        case 0: title = "Расписание"
//        case FavoriteTableSection: title = "Избранное"
//        default: ()
//        }
//        return title
//    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = favorites[sourceIndexPath.row]
        favorites.remove(at: sourceIndexPath.row)
        favorites.insert(item, at: destinationIndexPath.row)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = favorites[indexPath.row]

            FavoriteManager().removeFavorite(item)

            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateState()
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // MARK: - UITableViewDelegate

//    func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
//
//        if (proposedDestinationIndexPath.section != FavoriteTableSection) {
//            return sourceIndexPath
//        }
//        return proposedDestinationIndexPath
//    }
}
