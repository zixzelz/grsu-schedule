//
//  LessonScheduleCell.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class BaseLessonScheduleCell: UITableViewCell {

    @IBOutlet private(set) weak var locationLabel: UILabel!
    @IBOutlet private(set) weak var studyNameLabel: UILabel!
    @IBOutlet private(set) weak var studyTypeLabel: UILabel!
    @IBOutlet private(set) weak var studyLabelLabel: UILabel!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var stopTimeLabel: UILabel!

    var startTime: Int? {
        didSet {
            startTimeLabel.text = timeTextWithTimeInterval(startTime!)
        }
    }
    var stopTime: Int? {
        didSet {
            stopTimeLabel.text = timeTextWithTimeInterval(stopTime!)
        }
    }

    fileprivate func timeTextWithTimeInterval(_ interval: Int) -> String {
        let h: Int = interval / 60
        let m: Int = interval % 60

        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2

        return formatter.string(from: NSNumber(value: h))! + ":" + formatter.string(from: NSNumber(value: m))!
    }

}

@objc
protocol ActiveLessonScheduleCell: NSObjectProtocol {
    var lessonProgressView: UIProgressView! { get }
}

class LessonScheduleCell: UITableViewCell, ReusableCell {

    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var stopTimeLabel: UILabel!
    @IBOutlet private weak var studyTypeLabel: UILabel!
    @IBOutlet private weak var studyNameLabel: UILabel!
    @IBOutlet private weak var studySubNameLabel: UILabel!

    @IBOutlet private weak var subTitle1Label: UILabel!
    @IBOutlet private weak var subTitle2Label: UILabel!
    @IBOutlet private weak var subTitle3Label: UILabel!

    @IBOutlet private weak var timeContentView: UIView!
    @IBOutlet private weak var timeBorderView: UIView!
    @IBOutlet private weak var lessonProgressView: UIProgressView!

    var startTime: Int? {
        didSet {
            startTimeLabel.text = timeTextWithTimeInterval(startTime!)
        }
    }
    var stopTime: Int? {
        didSet {
            stopTimeLabel.text = timeTextWithTimeInterval(stopTime!)
        }
    }

    fileprivate func timeTextWithTimeInterval(_ interval: Int) -> String {
        let h: Int = interval / 60
        let m: Int = interval % 60

        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2

        return formatter.string(from: NSNumber(value: h))! + ":" + formatter.string(from: NSNumber(value: m))!
    }

}

extension LessonScheduleCell {
    func configureStuden(_ lesson: LessonScheduleEntity) {
        let startLessonTime = lesson.date.addingTimeInterval(TimeInterval(lesson.startTime * 60))
        let endLessonTime = lesson.date.addingTimeInterval(TimeInterval(lesson.stopTime * 60))
        let isActive = Date() > startLessonTime && Date() < endLessonTime

        startTimeLabel.text = timeTextWithTimeInterval(Int(lesson.startTime))
        stopTimeLabel.text = timeTextWithTimeInterval(Int(lesson.stopTime))

        studyTypeLabel.text = lesson.type
        studyNameLabel.text = lesson.studyName
        studySubNameLabel.setTextOrHide(lesson.label)

        let subgroupTitle = !NSString.isNilOrEmpty(lesson.subgroupTitle) ? "\(L10n.scheduleSubgroupTitle) \(lesson.subgroupTitle!)" : ""
        let teacherTitle = lesson.teacher?.title
        subTitle1Label.setTextOrHide(subgroupTitle)
        subTitle2Label.setTextOrHide(teacherTitle)

        if !NSString.isNilOrEmpty(lesson.address) || !NSString.isNilOrEmpty(lesson.room) {
            let room = lesson.room.isNilOrEmpty ? nil : "\(L10n.roomNumberTitle)\(lesson.room!)"
            let list = [lesson.address, room].compactMap { $0.isNilOrEmpty ? nil : $0 }
            subTitle3Label.text = list.joined(separator: "; ")
        } else {
            subTitle3Label.text = nil
        }

        timeContentView.backgroundColor = isActive ? Asset.Colors.scheduleActiveLessonColor.color : Asset.Colors.backgroundColor.color
        timeBorderView.isHidden = !isActive
        lessonProgressView.isHidden = !isActive

        if isActive {
            lessonProgressView.progress = Float((Date().timeIntervalSince(startLessonTime) / 60) / Double(lesson.stopTime - lesson.startTime))
        }
    }
    func configureTeacher(_ lesson: LessonScheduleEntity) {
        let startLessonTime = lesson.date.addingTimeInterval(TimeInterval(lesson.startTime * 60))
        let endLessonTime = lesson.date.addingTimeInterval(TimeInterval(lesson.stopTime * 60))
        let isActive = Date() > startLessonTime && Date() < endLessonTime

        startTimeLabel.text = timeTextWithTimeInterval(Int(lesson.startTime))
        stopTimeLabel.text = timeTextWithTimeInterval(Int(lesson.stopTime))

        studyTypeLabel.text = lesson.type
        studyNameLabel.text = lesson.studyName
        studySubNameLabel.setTextOrHide(lesson.label)

        let groups = lesson.groups
        let titles = groups.map { $0.title } as [String]
        subTitle1Label.text = groups.first?.faculty?.title
        subTitle2Label.text = titles.joined(separator: ", ")

        if !NSString.isNilOrEmpty(lesson.address) || !NSString.isNilOrEmpty(lesson.room) {
            let room = lesson.room.isNilOrEmpty ? nil : "\(L10n.roomNumberTitle)\(lesson.room!)"
            let list = [lesson.address, room].compactMap { $0.isNilOrEmpty ? nil : $0 }
            subTitle3Label.text = list.joined(separator: "; ")
        } else {
            subTitle3Label.text = nil
        }

        timeContentView.backgroundColor = isActive ? Asset.Colors.scheduleActiveLessonColor.color : Asset.Colors.backgroundColor.color
        timeBorderView.isHidden = !isActive
        lessonProgressView.isHidden = !isActive

        if isActive {
            lessonProgressView.progress = Float((Date().timeIntervalSince(startLessonTime) / 60) / Double(lesson.stopTime - lesson.startTime))
        }
    }
}
