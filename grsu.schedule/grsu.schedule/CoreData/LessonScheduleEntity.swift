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

    @NSManaged var date: NSDate
    @NSManaged var address: String?
    @NSManaged var room: String?
    @NSManaged var startTime: NSNumber
    @NSManaged var stopTime: NSNumber
    @NSManaged var studyName: String?
    @NSManaged var subgroupTitle: String?
    @NSManaged var type: String?
    @NSManaged var groups: Set<GroupsEntity>
    @NSManaged var teacher: TeacherInfoEntity?

    @NSManaged var isTeacherSchedule: NSNumber
}

enum ScheduleQueryInfo: QueryInfoType {
    case My(studentId: String)
    case Student(group: GroupsEntity)
    case Teacher(teacher: TeacherInfoEntity)
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

    static func objects(json: [String: AnyObject]) -> [[String: AnyObject]]? {

        guard let days = json["days"] as? [[String: AnyObject]] else { return nil }

        var items = [[String: AnyObject]]()
        for day in days {

            guard let strDate = day["date"] as? String else { return nil }
            guard var lessons = day["lessons"] as? [[String: AnyObject]] else { return nil }

            let date = DateUtils.dateFromString(strDate, format: DateFormatKeyDateInDefaultFormat)
            for index in 0 ..< lessons.count {
                lessons[index]["date"] = date
            }

            items.appendContentsOf(lessons)
        }

        return items
    }

    static func parsableContext(context: ManagedObjectContextType) -> LessonScheduleContext {

        let groupsLocalService = LocalService<GroupsEntity>()
        let teachersMap = TeacherInfoEntity.objectsMap(withPredicate: nil, inContext: context) ?? [:]

        return LessonScheduleContext(groupsLocalService: groupsLocalService, teachersMap: teachersMap)
    }

    func fill(json: [String: AnyObject], queryInfo: QueryInfo, context: LessonScheduleContext) {

        let lesson = json

        guard let moContext = managedObjectContext else { return }

        guard let lessonDate = lesson["date"] as? NSDate else { return }
        guard let timeStart = lesson["timeStart"] as? String else { return }
        guard let timeEnd = lesson["timeEnd"] as? String else { return }

        date = lessonDate
        studyName = lesson["title"] as? String
        type = lesson["type"] as? String
        address = lesson["address"] as? String
        room = lesson["room"] as? String
        startTime = DateManager.timeIntervalWithTimeText(timeStart)
        stopTime = DateManager.timeIntervalWithTimeText(timeEnd)
        subgroupTitle = lesson["subgroup"]?["title"] as? String

        switch queryInfo {
        case .Student(let _group):
            isTeacherSchedule = false
            let group = _group.convertInContext(moContext)
            groups = Set<GroupsEntity>(arrayLiteral: group)
            teacher = parseTeacher(lesson["teacher"], managedObjectContext: moContext, context: context)

        case .Teacher(let _teacher):
            isTeacherSchedule = true
            groups = parseGroups(lesson["groups"], managedObjectContext: moContext, context: context)
            teacher = _teacher.convertInContext(moContext)
            
        case .My(let studentId): break

        }
    }

    func update(json: [String: AnyObject], queryInfo: QueryInfo) {
    }

    //

    private func parseTeacher(teacherJson: AnyObject?, managedObjectContext: NSManagedObjectContext, context: LessonScheduleContext) -> TeacherInfoEntity? {

        guard let teacherJson = teacherJson as? [String: AnyObject] else { return nil }
        guard let teacherId = teacherJson["id"] as? String else { return nil }

        var newTeacher = context.teachersMap[teacherId]
        if newTeacher == nil {

            newTeacher = TeacherInfoEntity.insert(inContext: managedObjectContext)
            newTeacher?.id = teacherId
            newTeacher?.title = teacherJson["fullname"] as? String
            newTeacher?.post = teacherJson["post"] as? String

            context.teachersMap[teacherId] = newTeacher
        }
        return newTeacher
    }
    
    private func parseGroups(groupsJson: AnyObject?, managedObjectContext: NSManagedObjectContext, context: LessonScheduleContext) -> Set<GroupsEntity> {
        
        guard let groupsJson = groupsJson as? [[String: AnyObject]] else { return [] }
        
        var groups = Set<GroupsEntity>()
        for groupJson in groupsJson {
            
            if let newGroup = try? context.groupsLocalService.parseAndStoreItem(groupJson, context: managedObjectContext, queryInfo: .MakeAsHidden) {
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
