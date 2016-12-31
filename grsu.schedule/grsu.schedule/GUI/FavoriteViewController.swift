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
    
    var favorites: [FavoriteEntity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchFavorite()
    }
    
    func fetchFavorite() {
        let manager = FavoriteManager()
        
        manager.getAllFavorite { [weak self](items: Array<FavoriteEntity>) -> Void in
            if let wSelf = self {
                wSelf.favorites = items
                wSelf.tableView.reloadData()
                wSelf.updateState()
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
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let cdHelper = delegate.cdh
        cdHelper.saveContext(cdHelper.managedObjectContext)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSUserDefaults.standardUserDefaults().synchronize()
        
        if (segue.identifier == "StudentFavoriteSegueIdentifier" || segue.identifier == "TeacherFavoriteSegueIdentifier") {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let item = favorites![indexPath.row]
                let week = DateManager.scheduleWeeks()
                
                let scheduleQuery = DateScheduleQuery()
                scheduleQuery.startWeekDate = week.first!.startDate
                scheduleQuery.endWeekDate = week.first!.endDate
                
                if (segue.identifier == "StudentFavoriteSegueIdentifier") {
                    
                    let navigationController = segue.destinationViewController as! UINavigationController
                    let viewController = navigationController.topViewController as! StudentSchedulesPageViewController
                    viewController.possibleWeeks = week
                    viewController.dateScheduleQuery = scheduleQuery
                    viewController.group = item.group
                }
                if (segue.identifier == "TeacherFavoriteSegueIdentifier") {
                    
                    let viewController = segue.destinationViewController as! TeacherSchedulesPageViewController
                    viewController.possibleWeeks = week
                    viewController.dateScheduleQuery = scheduleQuery
                    viewController.teacher = item.teacher
                }
            }
        }
        
    }
    
    func updateState() {
        editButton.hidden = !(favorites?.count > 0)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favorites?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return favoriteCell(indexPath.row)
    }

    func favoriteCell(row: Int) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if let group = favorites![row].group {
            
            cell = tableView.dequeueReusableCellWithIdentifier("StudentFavoriteCellIdentifier")
            cell!.textLabel?.text = group.title
            
        } else if let teacher = favorites![row].teacher {
            
            cell = tableView.dequeueReusableCellWithIdentifier("TeacherFavoriteCellIdentifier")
            
            var text = teacher.title
            let texts = text!.componentsSeparatedByString(" ")
            
            if texts.count > 2 {
                
                text = texts[0]
                // + " " + texts[1].substringToIndex(advance(texts[1].startIndex, 1)) + ". " + texts[2].substringToIndex(advance(texts[2].startIndex, 1)) + "."
            }
            
            cell!.textLabel?.text = text
        } else {
            cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
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
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let item = favorites![sourceIndexPath.row]
        
        favorites!.removeAtIndex(sourceIndexPath.row)
        favorites!.insert(item, atIndex: destinationIndexPath.row)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let item = favorites![indexPath.row]
            FavoriteManager().removeFavorite(item)
            
            favorites!.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            updateState()
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
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