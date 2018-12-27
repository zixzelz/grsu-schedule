//
//  FacultiesEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/30/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation
import ServiceLayerSDK
import CoreData

@objc(FacultiesEntity)
class FacultiesEntity: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var id: String
    @NSManaged var groups: NSSet

}

enum FacultiesQueryInfo: QueryInfoType {
    case `default`
    case justInsert
}

extension FacultiesEntity: ModelType {

    typealias QueryInfo = FacultiesQueryInfo

//    static func keyForIdentifier() -> String? {
//        return "id"
//    }

    static func identifier(_ json: NSDictionary) throws -> String {
        guard let id = json.string(for: "id") else {
            throw ParseError.invalidData
        }
        return id
    }

    static func objects(_ json: NSDictionary) -> [NSDictionary]? {
        return json.dictArr(for: "items")
    }

    func fill(_ json: NSDictionary, queryInfo: QueryInfo, context: Void) throws {
        let identifier = try type(of: self).identifier(json)

        updateIfNeeded(keyPath: \FacultiesEntity.id, value: identifier)

        if queryInfo == .default {
            let fullTitle = json.stringValue(for: "title")
            let title = fullTitle.replacingOccurrences(of: "^Факультет ", with: "", options: NSString.CompareOptions.regularExpression, range: nil).capitalizingFirstLetter()
            updateIfNeeded(keyPath: \FacultiesEntity.title, value: title)
        }
    }

    func update(_ json: [String: AnyObject], queryInfo: QueryInfo) {

        if queryInfo == .default {

            let fullTitle = json["title"] as? String ?? ""
            title = fullTitle.replacingOccurrences(of: "^Факультет ", with: "", options: NSString.CompareOptions.regularExpression, range: nil).capitalizingFirstLetter()
        }
    }

    static func totalItems(_ json: NSDictionary) -> Int {
        return 0
    }

    // MARK: - ManagedObjectType

    var identifier: String {
        return id
    }

}
