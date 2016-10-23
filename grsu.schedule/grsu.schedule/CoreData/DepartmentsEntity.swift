//
//  DepartmentsEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/30/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation
import CoreData

@objc(DepartmentsEntity)
class DepartmentsEntity: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var id: String
    @NSManaged var groups: NSSet

}

extension DepartmentsEntity: ModelType {

    typealias QueryInfo = NoneQueryInfo

    static func keyForIdentifier() -> String {
        return "id"
    }

    static func objects(json: [String: AnyObject]) -> [[String: AnyObject]]? {

        return json["items"] as? [[String: AnyObject]]
    }

    func fill(json: [String: AnyObject], queryInfo: QueryInfo, context: Void) {

        id = json["id"] as! String

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
