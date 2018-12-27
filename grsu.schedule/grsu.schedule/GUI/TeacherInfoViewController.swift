
//
//  TeacherInfoViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/11/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import MessageUI
import Flurry_iOS_SDK
import ServiceLayerSDK

private enum GSTeacherFieldType: String {
    case skype = "TeacherSkypeFieldCellIdentifier"
    case email = "TeacherEmailFieldCellIdentifier"
    case phone = "TeacherPhoneFieldCellIdentifier"
}

private typealias GSTeacherField = (title: String, type: GSTeacherFieldType, value: String?)

class TeacherInfoViewController: UITableViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    private var teacherInfoFields: [GSTeacherField] = []
    var teacherInfo: TeacherInfoEntity? {
        didSet {
            if (teacherInfo?.id == "20200") {
                teacherInfo?.phone = "+375 29 320 9908"
                teacherInfo?.skype = "a.karkanica"
            }

            teacherInfoFields = []
            if let phone = teacherInfo?.phone, !NSString.isNilOrEmpty(phone) {
                teacherInfoFields.append((L10n.teacherInfoMobileFieldTitle, .phone, phone))
            }
            if let email = teacherInfo?.email, !NSString.isNilOrEmpty(email) {
                teacherInfoFields.append((L10n.teacherInfoEmailFieldTitle, .email, email))
            }
            if let skype = teacherInfo?.skype, !NSString.isNilOrEmpty(skype) {
                teacherInfoFields.append((L10n.teacherInfoSkypeFieldTitle, .skype, skype))
            }
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRefreshControl()
        fetchData()

        navigationItem.title = L10n.teacherInfoNavigationBarTitle
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let title = teacherInfo?.title {
            Flurry.logEvent("Teacher Info", withParameters: ["Teacher": title])
        }
    }

    func setupRefreshControl() {
        refreshControl?.addTarget(self, action: #selector(TeacherInfoViewController.refreshTeacherInfo(_:)), for: .valueChanged)
    }

    func scrollToTop() {
        let top = tableView.contentInset.top
        tableView.contentOffset = CGPoint(x: 0, y: -top)
    }

    func fetchData(_ useCache: Bool = true) {
        guard let teacherInfo = teacherInfo else { return }

        setNeedsShowRefreshControl()

        let cache: CachePolicy = useCache ? .cachedElseLoad : .reloadIgnoringCache
        TeachersService().getTeacher(teacherInfo.id, cache: cache).startWithResult { [weak self] result in
            guard let strongSelf = self else { return }

            strongSelf.hideRefreshControl()
            if case .success(teacherInfo) = result {
                strongSelf.teacherInfo = teacherInfo
            }
        }
    }

    @objc func refreshTeacherInfo(_ sender: AnyObject) {
        fetchData(false)
    }

    fileprivate func setNeedsShowRefreshControl() {

        if let refreshControl = refreshControl, !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
            //            scrollToTop()
        }
    }

    fileprivate func hideRefreshControl() {
        refreshControl?.endRefreshing()
    }

    @IBAction func donePressed() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - TeacherFieldAction

    lazy var overlayTransitioningDelegate = { return OverlayTransitioningDelegate() }()
    @IBAction func emailButtonPressed(_ sender: AnyObject) {

        guard let email = teacherInfo?.email else { return }

        if !MFMailComposeViewController.canSendMail() {
            return
        }

        let compose = MFMailComposeViewController()
        compose.mailComposeDelegate = self
        compose.setToRecipients([email])

        compose.modalPresentationStyle = .custom
        compose.transitioningDelegate = overlayTransitioningDelegate

        present(compose, animated: true, completion: nil)
    }

    @IBAction func phoneButtonPressed(_ sender: AnyObject) {
        let phoneNumber = NSString(format: "telprompt:%@", teacherInfo!.phone!.replacingOccurrences(of: " ", with: ""))
        let url = URL(string: phoneNumber as String)
        UIApplication.shared.openURL(url!)
    }

    @IBAction func messageButtonPressed(_ sender: AnyObject) {

        guard let phone = teacherInfo?.phone else { return }

        if !MFMessageComposeViewController.canSendText() {
            return
        }

        let compose = MFMessageComposeViewController()
        compose.messageComposeDelegate = self
        compose.recipients = [phone]

//        compose.modalPresentationStyle = .Custom
//        compose.transitioningDelegate = overlayTransitioningDelegate

        present(compose, animated: true, completion: nil)
    }

    @IBAction func skypeButtonPressed(_ sender: AnyObject) {

        guard let skype = teacherInfo?.skype,
            let url = URL(string: "skype:\(skype)") else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }

    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - MFMessageComposeViewControllerDelegate

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if (section == 1) {
            count = teacherInfoFields.count
        }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell

        if (indexPath.section == 0) {

            cell = tableView.dequeueReusableCell(withIdentifier: "TeacherPhotoCellIdentifier") as! TeacherPhotoTableViewCell
            cell.imageView?.image = photoById(teacherInfo?.id)
            cell.textLabel?.text = teacherInfo?.displayTitle
            cell.detailTextLabel?.text = teacherInfo?.post
        } else {

            let cellIdentifier = teacherInfoFields[indexPath.row].type.rawValue
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CustomSubtitleTableViewCell
            cell.textLabel?.text = teacherInfoFields[indexPath.row].title
            cell.detailTextLabel?.text = teacherInfoFields[indexPath.row].value ?? "  "
        }
        return cell
    }

    func photoById(_ id: String?) -> UIImage? {

        guard let id = id, let photo = UIImage(named: "Photo_\(id)") else {
            return UIImage(named: "UserPlaceholderIcon")
        }

        return photo
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 84 : 56
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        let field = teacherInfoFields[indexPath.row]

        switch field.type {
        case .email: emailButtonPressed(cell)
        case .phone: phoneButtonPressed(cell)
        case .skype: skypeButtonPressed(cell)
        }
    }

    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == 1)
    }

    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {

        return (action == #selector(copy(_:)))
    }

    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any!) {
        UIPasteboard.general.string = teacherInfoFields[indexPath.row].value
    }

}
