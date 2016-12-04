//
//  GroupsEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/29/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation
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
    case WithParams(faculty: FacultiesEntity, department: DepartmentsEntity, course: String)
    case MakeAsHidden
}

class GroupsParsableContext {
    lazy var departmentsLocalService: LocalService<DepartmentsEntity> = {
        return LocalService<DepartmentsEntity>()
    }()
    lazy var facultiesLocalService: LocalService<FacultiesEntity> = {
        return LocalService<FacultiesEntity>()
    }()
}

extension GroupsEntity: ModelType {

    typealias QueryInfo = GroupsServiceQueryInfo

    static func keyForIdentifier() -> String? {
        return "id"
    }

    static func objects(json: [String: AnyObject]) -> [[String: AnyObject]]? {
        return json["items"] as? [[String: AnyObject]]
    }
    
    static func parsableContext(context: ManagedObjectContextType) -> GroupsParsableContext {
        return GroupsParsableContext()
    }

    func fill(json: [String: AnyObject], queryInfo: QueryInfo, context: GroupsParsableContext) {

        id = json["id"] as! String
        
        guard let moContext = managedObjectContext else { return }
        switch queryInfo {
        case let .WithParams(faculty_, department_, course_):
            faculty = faculty_.convertInContext(moContext)
            department = department_.convertInContext(moContext)
            course = course_
        case .MakeAsHidden:
            let facultyJson = json["faculty"] as! [String: AnyObject]
            let departmentJson = json["department"] as! [String: AnyObject]
            faculty = try? context.facultiesLocalService.parseAndStoreItem(facultyJson, context: moContext, queryInfo: .JustInsert)
            department = try? context.departmentsLocalService.parseAndStoreItem(departmentJson, context: moContext, queryInfo: .JustInsert)
            course = json["course"] as! String
            hidden = true
        }

        update(json, queryInfo: queryInfo)
    }

    func update(json: [String: AnyObject], queryInfo: QueryInfo) {
        title = json["title"] as! String
    }

    // MARK: - ManagedObjectType

    var identifier: String? {

        return id
    }

}
