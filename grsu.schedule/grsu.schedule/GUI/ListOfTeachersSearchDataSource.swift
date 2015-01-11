//
//  ListOfTeachersSearchDataSource.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/16/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class ListOfTeachersSearchDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate {

    @IBOutlet var searchDisplayController: UISearchDisplayController!
    
    var items: [TeacherInfoEntity]?
    var searcheArray: [TeacherInfoEntity]?
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searcheArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?
        
        cell = tableView.dequeueReusableCellWithIdentifier("TeacherSearchCellIdentifier") as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "TeacherSearchCellIdentifier")
            cell?.accessoryType = .DetailDisclosureButton
            
        }
        cell?.textLabel?.text = searcheArray![indexPath.row].title
        
        return cell!
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        searchDisplayController.searchContentsController.performSegueWithIdentifier("TeacherInfoIdentifier", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    // MARK: - UISearchDisplayDelegate
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        let filtredArr = items?.filter { $0.title?.rangeOfString(searchString, options: .CaseInsensitiveSearch, range: nil, locale: nil) != nil }
        
        searcheArray = filtredArr
        
        return true
    }

}
