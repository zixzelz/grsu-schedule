//
//  LessonScheduleEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import Foundation
import ServiceLayerSDK
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
    var groupsMap: [String: GroupsEntity]
    var teachersMap: [String: TeacherInfoEntity]

    init(groupsMap: [String: GroupsEntity], teachersMap: [String: TeacherInfoEntity]) {
        self.groupsMap = groupsMap
        self.teachersMap = teachersMap
    }
}

extension LessonScheduleEntity: ModelType {

    struct Mapper {

        private let dict: NSDictionary

        public init(_ dict: NSDictionary) {
            self.dict = dict
        }

//        static func identifier(_ object: NSDictionary) -> String? {
//            //return object.string(for: "id")
//            return nil
//        }
//
//        var identifier: String? {
//            return type(of: self).identifier(dict)
//        }

        public static func addDate(_ object: NSDictionary, date: Date) -> NSDictionary {
            let result = object.mutableCopy() as! NSMutableDictionary//swiftlint:disable:this force_cast
            result["date"] = date
            return result.copy() as! NSDictionary//swiftlint:disable:this force_cast
        }

        var date: Date? {
            return dict.date(for: "date")
        }

        var studyName: String? {
            return dict.string(for: "title")
        }

        var type: String? {
            return dict.string(for: "type")
        }

        var address: String? {
            return dict.string(for: "address")
        }

        var room: String? {
            return dict.string(for: "room")
        }

        var startTime: Int32? {
            guard let startTime = dict.string(for: "timeStart") else {
                return nil
            }
            return DateManager.timeIntervalWithTimeText(startTime).map { Int32($0) }
        }

        var endTime: Int32? {
            guard let timeEnd = dict.string(for: "timeEnd") else {
                return nil
            }
            return DateManager.timeIntervalWithTimeText(timeEnd).map { Int32($0) }
        }

        var subgroup: String? {
            return dict.dict(for: "subgroup")?.string(for: "title")
        }

        var teacher: NSDictionary? {
            return dict.dict(for: "teacher")
        }

        var groups: [NSDictionary]? {
            return dict.dictArr(for: "groups")
        }

    }

    typealias QueryInfo = ScheduleQueryInfo

    static func identifier(_ json: NSDictionary) throws -> String {
        let lessonMap = Mapper(json)

        let startTime = lessonMap.startTime ?? 0
        let endTime = lessonMap.endTime ?? 0
        let studyName = lessonMap.studyName

        return "\(String(describing: studyName))-\(startTime)-\(endTime)"
    }

    static func objects(_ json: NSDictionary) -> [NSDictionary]? {

        guard let days = json.dictArr(for: "days") else { return nil }

        var items = [NSDictionary]()
        for day in days {

            guard let strDate = day.string(for: "date") else { return nil }
            guard var lessons = day.dictArr(for: "lessons") else { return nil }

            let date = DateUtils.date(from: strDate, format: DateFormatKeyDateInDefaultFormat)!
            lessons = lessons.map { Mapper.addDate($0, date: date) }

            items.append(contentsOf: lessons)
        }

        return items
    }

    static func parsableContext(_ context: ManagedObjectContextType) -> LessonScheduleContext {
// todo, think context, predicate
        let groupsMap = GroupsEntity.objectsMap(withPredicate: nil, inContext: context, sortBy: nil, keyForObject: nil) ?? [:]
        let teachersMap = TeacherInfoEntity.objectsMap(withPredicate: nil, inContext: context, sortBy: nil, keyForObject: nil) ?? [:]

        return LessonScheduleContext(groupsMap: groupsMap, teachersMap: teachersMap)
    }

    func fill(_ json: NSDictionary, queryInfo: QueryInfo, context: LessonScheduleContext) throws {
        let lessonMap = Mapper(json)

        guard let moContext = managedObjectContext else { return }

        guard let lessonDate = lessonMap.date,
            let startTime = lessonMap.startTime,
            let endTime = lessonMap.endTime
            else {
                throw ParseError.invalidData
        }

        date = lessonDate
        studyName = lessonMap.studyName
        type = lessonMap.type
        address = lessonMap.address
        room = lessonMap.room
        self.startTime = startTime
        self.stopTime = endTime
        subgroupTitle = lessonMap.subgroup

        updateIfNeeded(keyPath: \LessonScheduleEntity.date, value: lessonDate)
        updateIfNeeded(keyPath: \LessonScheduleEntity.studyName, value: lessonMap.studyName)
        updateIfNeeded(keyPath: \LessonScheduleEntity.type, value: lessonMap.type)
        updateIfNeeded(keyPath: \LessonScheduleEntity.address, value: lessonMap.address)
        updateIfNeeded(keyPath: \LessonScheduleEntity.room, value: lessonMap.room)
        updateIfNeeded(keyPath: \LessonScheduleEntity.startTime, value: startTime)
        updateIfNeeded(keyPath: \LessonScheduleEntity.stopTime, value: endTime)
        updateIfNeeded(keyPath: \LessonScheduleEntity.subgroupTitle, value: lessonMap.subgroup)

        switch queryInfo {
        case .student(let _group):
            isTeacherSchedule = false
            let group = _group.existingObject(in: moContext)
            groups = group.map { Set<GroupsEntity>(arrayLiteral: $0) } ?? []
            teacher = lessonMap.teacher.flatMap { teacher in
                return parseTeacher(teacher, managedObjectContext: moContext, context: context)
            }

        case .teacher(let _teacher):
            isTeacherSchedule = true
            groups = lessonMap.groups.map { groups in
                return parseGroups(groups, managedObjectContext: moContext, context: context)
            } ?? []
            teacher = _teacher.existingObject(in: moContext)

        case .my(let _studentId):
            isTeacherSchedule = false
            userId = _studentId
            groups = lessonMap.groups.map { groups in
                return parseGroups(groups, managedObjectContext: moContext, context: context)
            } ?? []
            teacher = lessonMap.teacher.flatMap { teacher in
                return parseTeacher(teacher, managedObjectContext: moContext, context: context)
            }

        }
    }

    //

    private func parseTeacher(_ teacherJson: NSDictionary, managedObjectContext: NSManagedObjectContext, context: LessonScheduleContext) -> TeacherInfoEntity? {
        let teacherLocalService = LocalService<TeacherInfoEntity>(contextProvider: CoreDataHelper.contextProvider())

        guard let newTeacher = try? teacherLocalService.parseAndStoreItem(teacherJson, cachedItemsMap: context.teachersMap, context: managedObjectContext, queryInfo: .default) else {
            return nil
        }
        context.teachersMap[newTeacher.identifier] = newTeacher
        return newTeacher
    }

    private func parseGroups(_ groupsJson: [NSDictionary], managedObjectContext: NSManagedObjectContext, context: LessonScheduleContext) -> Set<GroupsEntity> {
        let groupsLocalService = LocalService<GroupsEntity>(contextProvider: CoreDataHelper.contextProvider())

        var groups = Set<GroupsEntity>()
        for groupJson in groupsJson {
            if let newGroup = try? groupsLocalService.parseAndStoreItem(groupJson, cachedItemsMap: context.groupsMap, context: managedObjectContext, queryInfo: .makeAsHidden) {
                context.groupsMap[newGroup.identifier] = newGroup
                groups.insert(newGroup)
            }
        }
        return groups
    }

    static func totalItems(_ json: NSDictionary) -> Int {
        return 0
    }

    // MARK: - ManagedObjectType

    var identifier: String {
        return "\(String(describing: studyName))-\(startTime)-\(stopTime)"
    }

}
