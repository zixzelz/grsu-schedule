//
//  LeftSubpageViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/8/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

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
        for i in (0...favorites!.count-1) {
            favorites![i].order = i
        }
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        cdHelper.saveContext(cdHelper.managedObjectContext!)
    }
    
    // pragma mark - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCellIdentifier") as UITableViewCell
        cell.textLabel?.text = favorites![indexPath.row].group.title
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favorites"
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
    
    // pragma mark - UITableViewDelegate
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
}
