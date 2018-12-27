//
//  DepartmentsEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/30/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation
import ServiceLayerSDK
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

    struct Mapper {

        private let dict: NSDictionary

        public init(_ dict: NSDictionary) {
            self.dict = dict
        }

        static func identifier(_ object: NSDictionary) -> String? {
            return object.string(for: "id")
        }

        var identifier: String? {
            return type(of: self).identifier(dict)
        }

        var title: String {
            let str = dict.stringValue(for: "title")
            return str
        }

    }

    typealias QueryInfo = DepartmentsQueryInfo

    static func identifier(_ json: NSDictionary) throws -> String {
        guard let id = Mapper.identifier(json) else {
            throw ParseError.invalidData
        }
        return id
    }

    static func objects(_ json: NSDictionary) -> [NSDictionary]? {
        return json.dictArr(for: "items")
    }

    func fill(_ json: NSDictionary, queryInfo: QueryInfo, context: Void) throws {
        let identifier = try DepartmentsEntity.identifier(json)

        let mapper = Mapper(json)
        updateIfNeeded(keyPath: \DepartmentsEntity.id, value: identifier)

        if queryInfo == .default {
            updateIfNeeded(keyPath: \DepartmentsEntity.title, value: mapper.title.capitalizingFirstLetter())
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
