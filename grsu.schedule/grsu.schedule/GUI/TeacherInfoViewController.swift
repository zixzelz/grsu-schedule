
//
//  TeacherInfoViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/11/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class TeacherInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var teacherInfo: TeacherInfoEntity!
    let teacherInfoFields: [String]
    
    @IBOutlet private var tableView : UITableView!
    var refreshControl:UIRefreshControl!

    
    required init(coder aDecoder: NSCoder) {
        teacherInfoFields = ["Сотовый", "Email", "Skype"]
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        fetchData()
    }
    
    func setupRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refreshTeacherInfo:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func fetchData(useCache: Bool = true) {
//        if (!self.refreshControl.refreshing) {
//            self.refreshControl.beginRefreshing()
//        }
        
//        GetTeachersService.getTeachers { [weak self](items: Array<TeacherInfoEntity>?, error: NSError?) -> Void in
//            if let wSelf = self {
//                wSelf.refreshControl.endRefreshing()
//                wSelf.teacherInfo = items
//                wSelf.tableView.reloadData()
//            }
//        }
    }
    
    func refreshTeacherInfo(sender:AnyObject) {
        fetchData(useCache: false)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if (section == 1) {
            count = teacherInfoFields.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        
        if (indexPath.section == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("TeacherPhotoCellIdentifier") as TeacherPhotoTableViewCell
            cell.imageView?.image = UIImage(named: "UserPlaceholderIcon")
            cell.textLabel?.text = teacherInfo.title
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("TeacherFieldCellIdentifier") as UITableViewCell
            cell.textLabel?.text = teacherInfoFields[indexPath.row]
            cell.detailTextLabel?.text = teacherInfo.phone ?? "+375 29 882 65 15"
        }
        
        return cell
    }

}
