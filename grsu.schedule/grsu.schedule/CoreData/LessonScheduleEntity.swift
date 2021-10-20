//
//  LessonScheduleEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import Foundation
import CoreData

@objc(LessonScheduleEntity)
class LessonScheduleEntity: NSManagedObject {

    @NSManaged var date: Date
    @NSManaged var address: String?
    @NSManaged var room: String?
    @NSManaged var startTime: Int32
    @NSManaged var stopTime: Int32
    @NSManaged var studyName: String?
    @NSManaged var subgroupTitle: String?
    @NSManaged var type: String?
    @NSManaged var label: String?
    @NSManaged var groups: Set<GroupsEntity>
    @NSManaged var teacher: TeacherInfoEntity?

    @NSManaged var isTeacherSchedule: NSNumber
    @NSManaged var userId: String?
}

enum ScheduleQueryInfo: QueryInfoType {
    case my(studentId: String)
    case student(group: GroupsEntity)
    case teacher(teacher: TeacherInfoEntity)
}

class LessonScheduleContext {
    var groupsLocalService: LocalService<GroupsEntity>
    var teachersMap: [String: TeacherInfoEntity]

    init(groupsLocalService: LocalService<GroupsEntity>, teachersMap: [String: TeacherInfoEntity]) {
        self.groupsLocalService = groupsLocalService
        self.teachersMap = teachersMap
    }
}

extension LessonScheduleEntity: ModelType {

    typealias QueryInfo = ScheduleQueryInfo

    static func keyForIdentifier() -> String? {
        return nil
    }

    static func objects(_ json: [String: AnyObject]) -> [[String: AnyObject]]? {

        guard let days = json["days"] as? [[String: AnyObject]] else { return nil }

        var items = [[String: AnyObject]]()
        for day in days {

            guard let strDate = day["date"] as? String else { return nil }
            guard var lessons = day["lessons"] as? [[String: AnyObject]] else { return nil }

            let date = DateUtils.date(from: strDate, format: DateFormatKeyDateInDefaultFormat)
            for index in 0 ..< lessons.count {
                lessons[index]["date"] = date as AnyObject
            }

            items.append(contentsOf: lessons)
        }

        return items
    }

    static func parsableContext(_ context: ManagedObjectContextType) -> LessonScheduleContext {

        let groupsLocalService = LocalService<GroupsEntity>()
        let teachersMap = TeacherInfoEntity.objectsMap(withPredicate: nil, inContext: context) ?? [:]

        return LessonScheduleContext(groupsLocalService: groupsLocalService, teachersMap: teachersMap)
    }

    func fill(_ json: [String: AnyObject], queryInfo: QueryInfo, context: LessonScheduleContext) {

        let lesson = json

        guard let moContext = managedObjectContext else { return }

        guard let lessonDate = lesson["date"] as? Date else { return }
        guard let timeStart = lesson["timeStart"] as? String else { return }
        guard let timeEnd = lesson["timeEnd"] as? String else { return }

        date = lessonDate
        studyName = lesson["title"] as? String
        type = lesson["type"] as? String
        label = lesson["label"] as? String
        address = lesson["address"] as? String
        room = lesson["room"] as? String
        startTime = DateManager.timeIntervalWithTimeText(timeStart).map { Int32($0) } ?? 0
        stopTime = DateManager.timeIntervalWithTimeText(timeEnd).map { Int32($0) } ?? 0
        subgroupTitle = lesson["subgroup"]?["title"] as? String

        switch queryInfo {
        case .student(let _group):
            isTeacherSchedule = false
            let group = _group.convertInContext(moContext)
            groups = Set<GroupsEntity>(arrayLiteral: group)
            teacher = parseTeacher(lesson["teacher"], managedObjectContext: moContext, context: context)

        case .teacher(let _teacher):
            isTeacherSchedule = true
            groups = parseGroups(lesson["groups"], managedObjectContext: moContext, context: context)
            teacher = _teacher.convertInContext(moContext)

        case .my(let _studentId):
            isTeacherSchedule = false
            userId = _studentId
            groups = parseGroups(lesson["groups"], managedObjectContext: moContext, context: context)
            teacher = parseTeacher(lesson["teacher"], managedObjectContext: moContext, context: context)

        }
    }

    func update(_ json: [String: AnyObject], queryInfo: QueryInfo) {
    }

    //

    fileprivate func parseTeacher(_ teacherJson: AnyObject?, managedObjectContext: NSManagedObjectContext, context: LessonScheduleContext) -> TeacherInfoEntity? {

        guard let teacherJson = teacherJson as? [String: AnyObject] else { return nil }
        guard let teacherId = teacherJson["id"] as? String else { return nil }

        var newTeacher = context.teachersMap[teacherId]

        if newTeacher == nil {
            newTeacher = TeacherInfoEntity.insert(inContext: managedObjectContext)
            newTeacher?.id = teacherId
            context.teachersMap[teacherId] = newTeacher
        }

        newTeacher?.title = teacherJson["fullname"] as? String
        newTeacher?.post = teacherJson["post"] as? String

        return newTeacher
    }

    fileprivate func parseGroups(_ groupsJson: AnyObject?, managedObjectContext: NSManagedObjectContext, context: LessonScheduleContext) -> Set<GroupsEntity> {

        guard let groupsJson = groupsJson as? [[String: AnyObject]] else { return [] }

        var groups = Set<GroupsEntity>()
        for groupJson in groupsJson {

            if let newGroup = try? context.groupsLocalService.parseAndStoreItem(groupJson, context: managedObjectContext, queryInfo: .makeAsHidden) {
                groups.insert(newGroup)
            }
        }

        return groups
    }

    // MARK: - ManagedObjectType

    var identifier: String? {
        return nil
    }

}
