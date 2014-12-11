//
//  LeftSubpageViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/8/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

let FavoriteTableSection = 1

class LeftSubpageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var favorites: Array<FavoriteEntity>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchFavorite()
    }
    
    func fetchFavorite() {
        let manager = FavoriteManager()
        
        manager.getFavoriteStudentGroup { [weak self] (items: Array<FavoriteEntity>) -> Void in
            if let wSelf = self {
                wSelf.favorites = items
                wSelf.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func editButtonPressed(sender: UIButton) {
        
        if (tableView.editing) {
            updateFavoriteOrder()
        }
        
        tableView.setEditing(!tableView.editing, animated: true)
        sender.selected = tableView.editing
    }
    
    func updateFavoriteOrder() {
        for i in 0..<favorites!.count {
            favorites![i].order = i
        }
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        cdHelper.saveContext(cdHelper.managedObjectContext!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSUserDefaults.standardUserDefaults().synchronize()
        if (segue.identifier == "SchedulePageIdentifier" && tableView.indexPathForSelectedRow() != nil) {
            
            let item = favorites![tableView.indexPathForSelectedRow()!.row]
            
            let week = WeekManager.scheduleWeeks()
            
            let scheduleQuery = StudentScheduleQuery()
            scheduleQuery.group = item.group
            scheduleQuery.startWeekDate = week.first!.startDate
            scheduleQuery.endWeekDate = week.first!.endDate
            
            let navigationController = segue.destinationViewController as UINavigationController
            let viewController = navigationController.topViewController as SchedulesPageViewController
            viewController.possibleWeeks = week
            viewController.scheduleQuery = scheduleQuery
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int
        switch (section) {
        case 0: count = 2
        case FavoriteTableSection: count = favorites?.count ?? 0
        default: count = 0
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?
        switch (indexPath.section) {
        case 0: cell = schrduleCell(indexPath.row)
        case FavoriteTableSection: cell = favoriteCell(indexPath.row)
        default: ()
        }
        
        return cell!
    }
    
    func schrduleCell(row: Int) -> UITableViewCell {
        var cell : UITableViewCell?
        switch (row) {
        case 0: cell = tableView.dequeueReusableCellWithIdentifier("StudentCellIdentifier") as? UITableViewCell
        case 1: cell = tableView.dequeueReusableCellWithIdentifier("TeacherCellIdentifier") as? UITableViewCell
        default: ()
        }
        
        return cell!
    }
    
    func favoriteCell(row: Int) -> UITableViewCell {
        var cell : UITableViewCell
        cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCellIdentifier") as UITableViewCell
        cell.textLabel?.text = favorites![row].group.title
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title : String?
        switch (section) {
        case 0: title = "Расписание"
        case FavoriteTableSection: title = "Favorites"
        default: ()
        }
        return title
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let item = favorites![sourceIndexPath.row]
        
        favorites!.removeAtIndex(sourceIndexPath.row)
        favorites!.insert(item, atIndex: destinationIndexPath.row)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let item = favorites![indexPath.row]
            FavoriteManager().removeFavorite(item)
            
            favorites!.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == FavoriteTableSection
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == FavoriteTableSection
    }

    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if (proposedDestinationIndexPath.section != FavoriteTableSection) {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let item = favorites![indexPath.row]
//
//        let week = WeekManager.scheduleWeeks()
//        
//        let scheduleQuery = StudentScheduleQuery()
//        scheduleQuery.group = item.group
//        scheduleQuery.startWeekDate = week.first!.startDate
//        scheduleQuery.endWeekDate = week.first!.endDate
//        
//        let viewController = SchedulesPageViewController()
//        viewController.possibleWeeks = week
//        viewController.scheduleQuery = scheduleQuery
//
//
//    }
    
}
