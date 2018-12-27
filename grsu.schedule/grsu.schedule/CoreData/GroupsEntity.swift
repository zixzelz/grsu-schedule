//
//  GroupsEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/29/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation
import ServiceLayerSDK
import CoreData

@objc(GroupsEntity)
class GroupsEntity: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var id: String
    @NSManaged var course: String
    @NSManaged var lessons: NSSet
    @NSManaged var department: DepartmentsEntity?
    @NSManaged var faculty: FacultiesEntity?
    @NSManaged var favorite: FavoriteEntity?
    @NSManaged var hidden: NSNumber

}

enum GroupsServiceQueryInfo: QueryInfoType {
    case withParams(faculty: FacultiesEntity, department: DepartmentsEntity, course: String)
    case makeAsHidden
}

extension GroupsEntity: ModelType {

    class GroupsParsableContext {
        var departmentsMap: [String: DepartmentsEntity]
        var facultiesMap: [String: FacultiesEntity]

        init(departmentsMap: [String: DepartmentsEntity], facultiesMap: [String: FacultiesEntity]) {
            self.departmentsMap = departmentsMap
            self.facultiesMap = facultiesMap
        }
    }

    typealias QueryInfo = GroupsServiceQueryInfo

    static func objects(_ json: NSDictionary) -> [NSDictionary]? {
        return json.dictArr(for: "items")
    }

    static func parsableContext(_ context: ManagedObjectContextType) -> GroupsParsableContext {
        return GroupsParsableContext(
            departmentsMap: DepartmentsEntity.objectsMap(withPredicate: nil, inContext: context, sortBy: nil, keyForObject: nil) ?? [:],
            facultiesMap: FacultiesEntity.objectsMap(withPredicate: nil, inContext: context, sortBy: nil, keyForObject: nil) ?? [:]
        )
    }

    static func identifier(_ json: NSDictionary) throws -> String {
        guard let id = json["id"] as? String else {
            throw ParseError.invalidData
        }
        return id
    }

    func fill(_ json: NSDictionary, queryInfo: QueryInfo, context: GroupsParsableContext) throws {
        let identifier = try GroupsEntity.identifier(json)

        updateIfNeeded(keyPath: \GroupsEntity.id, value: identifier)

        guard let currentContext = managedObjectContext else { return }
        switch queryInfo {
        case let .withParams(faculty_, department_, course_):
            faculty = faculty_.existingObject(in: currentContext)
            department = department_.existingObject(in: currentContext)
            course = course_
        case .makeAsHidden:
            if let facultyJson = json.dict(for: "faculty") {
                let facultiesLocalService = LocalService<FacultiesEntity>(contextProvider: CoreDataHelper.contextProvider())
                faculty = try? facultiesLocalService.parseAndStoreItem(facultyJson, cachedItemsMap: context.facultiesMap, context: currentContext, queryInfo: .justInsert)
            } else {
                faculty = nil
            }
            
            if let departmentJson = json.dict(for: "department") {
                let departmentsLocalService = LocalService<DepartmentsEntity>(contextProvider: CoreDataHelper.contextProvider())
                department = try? departmentsLocalService.parseAndStoreItem(departmentJson, cachedItemsMap: context.departmentsMap, context: currentContext, queryInfo: .justInsert)
            }
            course = json["course"] as! String
            hidden = true
        }

        updateIfNeeded(keyPath: \GroupsEntity.title, value: json.stringValue(for: "title"))
    }

    static func totalItems(_ json: NSDictionary) -> Int {
        return 0
    }

    // MARK: - ManagedObjectType

    var identifier: String {
        return id
    }

}
