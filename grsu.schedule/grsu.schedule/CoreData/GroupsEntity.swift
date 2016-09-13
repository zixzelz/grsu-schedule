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

}

extension GroupsEntity: ModelType {

    typealias QueryInfo = GroupsServiceQueryInfo

    static func keyForIdentifier() -> String {
        return "id"
    }

    static func keyForEnumerateObjects() -> String {
        return "items"
    }

    func fill(json: [String: AnyObject], queryInfo: QueryInfo) {

        id = json["id"] as! String

        if case let .Default(faculty, department, course) = queryInfo {

            let context = managedObjectContext!

            self.faculty = faculty.convertInContext(context)
            self.department = department.convertInContext(context)
            self.course = course
        }

        update(json, queryInfo: queryInfo)
    }

    func update(json: [String: AnyObject], queryInfo: QueryInfo) {
        title = json["title"] as! String
    }

    // MARK: - ManagedObjectType

    var identifier: String {

        return id
    }

}
