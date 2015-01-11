
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
            if (teacherInfo.id == "20200") {
                teacherInfo.phone = "+375 29 320 9908"
                teacherInfo.skype = "a.karkanica"
            }

            
            teacherInfoFields = [];
            if !NSString.isNilOrEmpty(teacherInfo.phone) {
                teacherInfoFields.append(("Сотовый", .Phone, teacherInfo.phone))
            }
            if !NSString.isNilOrEmpty(teacherInfo.email) {
                teacherInfoFields.append(("Email", .Email, teacherInfo.email))
            }
            if !NSString.isNilOrEmpty(teacherInfo.skype) {
                teacherInfoFields.append(("Skype", .Skype, teacherInfo.skype))
            }
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
    
    func scrollToTop() {
        let top = self.tableView.contentInset.top
        self.tableView.contentOffset = CGPointMake(0, -top)
    }

    func fetchData(useCache: Bool = true) {
        if (!self.refreshControl!.refreshing) {
            self.refreshControl!.beginRefreshing()
            scrollToTop()
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
        let phoneNumber = NSString(format: "telprompt:%@", teacherInfo!.phone!.stringByReplacingOccurrencesOfString(" ", withString: ""))
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
        let skype = NSString(format: "skype:%@", teacherInfo.skype!)
        let url = NSURL(string: skype)
        if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
        }
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
            cell.imageView?.image = photoById(teacherInfo.id)
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
    
    func photoById(id: String) -> UIImage {
        var photo = UIImage(named: "Photo_\(id)")
        if photo == nil {
            photo = UIImage(named: "UserPlaceholderIcon")
        }
        return photo!
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 84 : 56
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let field = teacherInfoFields[indexPath.row]
        
        switch (field.type) {
        case .Email: emailButtonPressed(tableView.cellForRowAtIndexPath(indexPath)!)
        case .Phone: phoneButtonPressed(tableView.cellForRowAtIndexPath(indexPath)!)
        case .Skype: skypeButtonPressed(tableView.cellForRowAtIndexPath(indexPath)!)
        }
    }
    
    override func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return (indexPath.section == 1)
    }
    
    override func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject) -> Bool {
        return (action == "copy:")
    }
    
    override func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) {
        UIPasteboard.generalPasteboard().string = teacherInfoFields[indexPath.row].value
    }
    
}
