
//
//  TeacherInfoViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/11/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import MessageUI

enum GSTeacherFieldType : String {
    case Skype = "TeacherSkypeFieldCellIdentifier"
    case Email = "TeacherEmailFieldCellIdentifier"
    case Phone = "TeacherPhoneFieldCellIdentifier"
}

typealias GSTeacherField = (title: String, type: GSTeacherFieldType, value: String?)

class TeacherInfoViewController: UITableViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    var teacherInfoFields: [GSTeacherField]!
    var teacherInfo: TeacherInfoEntity! {
        didSet {
            teacherInfoFields = [];
            teacherInfoFields.append(("Сотовый", .Phone, "+375 29 882 6515"))
//            if !NSString.isNilOrEmpty(teacherInfo.phone) {
//                teacherInfoFields.append(("Сотовый", .Phone, teacherInfo.phone))
//            }
            if !NSString.isNilOrEmpty(teacherInfo.email) {
                teacherInfoFields.append(("Email", .Email, teacherInfo.email))
            }
            teacherInfoFields.append(("Skype", .Skype, "zixzelz"))
//            if !NSString.isNilOrEmpty(teacherInfo.skype) {
//                teacherInfoFields.append(("Skype", .Skype, teacherInfo.skype))
//            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        fetchData()
    }
    
    func setupRefreshControl() {
        self.refreshControl!.addTarget(self, action: "refreshTeacherInfo:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func fetchData(useCache: Bool = true) {
        if (!self.refreshControl!.refreshing) {
            self.refreshControl!.beginRefreshing()
        }
        
        GetTeachersService.getTeacher(teacherInfo.id, useCache: useCache) { [weak self](teacherInfo: TeacherInfoEntity?, error: NSError?) -> Void in
            if let wSelf = self {
                wSelf.refreshControl!.endRefreshing()
                wSelf.teacherInfo = teacherInfo
                wSelf.tableView.reloadData()
            }
        }
    }
    
    func refreshTeacherInfo(sender:AnyObject) {
        fetchData(useCache: false)
    }

    // MARK: - TeacherFieldAction

    @IBAction func emailButtonPressed(sender: AnyObject) {
        
        let compose = MFMailComposeViewController()
        compose.mailComposeDelegate = self
        compose.setToRecipients([teacherInfo.email!])
        
        self.presentViewController(compose, animated: true, completion: nil)
    }
    
    @IBAction func phoneButtonPressed(sender: AnyObject) {
        let phoneNumber = NSString(format: "telprompt:%@", "+375 29 882 65 15".stringByReplacingOccurrencesOfString(" ", withString: ""))
        let url = NSURL(string: phoneNumber)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func messageButtonPressed(sender: AnyObject) {
        if !MFMessageComposeViewController.canSendText() {
            return
        }
        
        let compose = MFMessageComposeViewController()
        compose.messageComposeDelegate = self
        compose.recipients = [teacherInfo.phone!]
        
        self.presentViewController(compose, animated: true, completion: nil)
    }
    
    @IBAction func skypeButtonPressed(sender: AnyObject) {
        
    }

    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - MFMessageComposeViewControllerDelegate
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if (section == 1) {
            count = teacherInfoFields.count
        }
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        
        if (indexPath.section == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("TeacherPhotoCellIdentifier") as TeacherPhotoTableViewCell
            cell.imageView?.image = UIImage(named: "UserPlaceholderIcon")
            cell.textLabel?.text = teacherInfo.title
            cell.detailTextLabel?.text = teacherInfo.post
        } else {
            let cellIdentifier = teacherInfoFields[indexPath.row].type.rawValue
            
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as CustomSubtitleTableViewCell
            cell.textLabel?.text = teacherInfoFields[indexPath.row].title
            cell.detailTextLabel?.text = teacherInfoFields[indexPath.row].value ?? "  "
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 83 : 56
    }

}
