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

enum DepartmentsQueryInfo: QueryInfoType {
    case `default`
    case justInsert
}

extension DepartmentsEntity: ModelType {

    typealias QueryInfo = DepartmentsQueryInfo

    static func keyForIdentifier() -> String? {
        return "id"
    }

    static func objects(_ json: [String: AnyObject]) -> [[String: AnyObject]]? {

        return json["items"] as? [[String: AnyObject]]
    }

    func fill(_ json: [String: AnyObject], queryInfo: QueryInfo, context: Void) {

        id = json["id"] as! String
        update(json, queryInfo: queryInfo)
    }

    func update(_ json: [String: AnyObject], queryInfo: QueryInfo) {

        if queryInfo == .default {
            
            let str = json["title"] as? String ?? ""
            title = str.capitalizingFirstLetter()
        }
    }

    // MARK: - ManagedObjectType

    var identifier: String? {

        return id
    }

}
