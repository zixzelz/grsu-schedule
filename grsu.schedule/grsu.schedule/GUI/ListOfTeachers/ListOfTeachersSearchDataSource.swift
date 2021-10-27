//
//  ListOfTeachersSearchDataSource.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/16/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class ListOfTeachersResultController: UITableViewController {

    var items: [TeacherInfoEntity]?
    var filteredItems: [TeacherInfoEntity]?

    weak var paretViewController: UIViewController?

    private func filterContentForSearchText(_ searchText: String?) {

        guard let searchText = searchText, searchText.utf8.count > 0 else {
            filteredItems = nil
            tableView.reloadData()
            return
        }

        filteredItems = items?.filter { $0.displayTitle.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell?

        cell = tableView.dequeueReusableCell(withIdentifier: "TeacherSearchCellIdentifier")

        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "TeacherSearchCellIdentifier")
            cell?.accessoryType = .detailDisclosureButton
        }
        cell?.textLabel?.text = filteredItems?[indexPath.row].displayTitle

        return cell!
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        paretViewController?.performSegue(withIdentifier: "TeacherInfoIdentifier", sender: tableView.cellForRow(at: indexPath))
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        paretViewController?.performSegue(withIdentifier: "SchedulePageIdentifier", sender: tableView.cellForRow(at: indexPath))
    }

}

extension ListOfTeachersResultController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text)
    }
}
