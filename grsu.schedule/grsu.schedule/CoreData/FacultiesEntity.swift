//
//  FacultiesEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/30/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation
import CoreData

@objc(FacultiesEntity)
class FacultiesEntity: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var id: String
    @NSManaged var groups: NSSet

}

extension FacultiesEntity: ModelType {

    typealias QueryInfo = NoneQueryInfo

    static func keyForIdentifier() -> String {
        return "id"
    }

    static func keyForEnumerateObjects() -> String {
        return "items"
    }

    func fill(json: [String: AnyObject], queryInfo: QueryInfo) {

        id = json["id"] as! String

        update(json, queryInfo: queryInfo)
    }

    func update(json: [String: AnyObject], queryInfo: QueryInfo) {

        let fullTitle = json["title"] as! String
        title = fullTitle.stringByReplacingOccurrencesOfString("^Факультет ", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        // TODO:
        // let nsRange = Range<String.Index>(start: advance(title.startIndex, 0), end: advance(title.startIndex, 1))
        // title = title.stringByReplacingCharactersInRange(nsRange, withString: title.substringToIndex(advance(title.startIndex, 1)).capitalizedString)    }
    }

    // MARK: - ManagedObjectType

    var identifier: String {

        return id
    }

}
