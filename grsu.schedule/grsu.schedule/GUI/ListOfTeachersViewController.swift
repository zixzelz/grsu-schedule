//
//  ListOfTeachersViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/10/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class ListOfTeachersViewController: UIViewController {

    var teachers: Array<TeacherInfoEntity>?
    
    @IBOutlet private var tableView : UITableView!
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "WeekSchedulesHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: SectionHeaderIdentifier)
        
        setupRefreshControl()
        fetchData()
    }
    
    func setupRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func fetchData(useCache: Bool = true) {
        if (!self.refreshControl.refreshing) {
            self.refreshControl.beginRefreshing()
        }
        
        GetTeachersService.getTeachers { [weak self](items: Array<TeacherInfoEntity>?, error: NSError?) -> Void in
            if let wSelf = self {
                wSelf.refreshControl.endRefreshing()
                wSelf.teachers = items
                wSelf.tableView.reloadData()
            }
        }
    }
    
    func refresh(sender:AnyObject) {
        fetchData(useCache: false)
    }
    
    // pragma mark - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var count = 1
        if (teachers == nil) {
            count = 0
        }
        return count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if (teachers != nil && teachers?.count > 0) {
            count = teachers!.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        
        if (teachers == nil || teachers?.count == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("EmptyCellIdentifier") as UITableViewCell
        } else {
            
            var teacher = teachers![indexPath.row]

            cell = tableView.dequeueReusableCellWithIdentifier("TeacherCellIdentifier") as UITableViewCell
            cell.textLabel?.text = teacher.title
        }
        
        return cell
    }
    
}
