//
//  TeacherInfoEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import Foundation
import CoreData

@objc(TeacherInfoEntity)
class TeacherInfoEntity: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var title: String?
    @NSManaged var name: String?
    @NSManaged var surname: String?
    @NSManaged var patronym: String?
    @NSManaged var post: String?
    @NSManaged var phone: String?
    @NSManaged var descr: String?
    @NSManaged var email: String?
    @NSManaged var skype: String?
    @NSManaged var updatedDate: Date
    @NSManaged var lessons: NSSet
    @NSManaged var favorite: FavoriteEntity?

}

extension TeacherInfoEntity: ModelType {

    typealias QueryInfo = TeachersServiceQueryInfo

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

        if let fullname = json["fullname"] as? String {
            title = fullname
        }
        if let _name = json["name"] as? String {
            name = _name
        }
        if let _surname = json["surname"] as? String {
            surname = _surname
        }
        if let _patronym = json["patronym"] as? String {
            patronym = _patronym
        }
        if let _post = json["post"] as? String {
            post = _post
        }
        if let _phone = json["phone"] as? String {
            phone = _phone
        }
        if let _descr = json["descr"] as? String {
            descr = _descr
        }
        if let _email = json["email"] as? String {
            email = _email
        }
        if let _skype = json["skype"] as? String {
            skype = _skype
        }
        updatedDate = Date()
    }

    var displayTitle: String {
        if let _title = title {
            return _title
        } else {
            var arr = [String]()
            if let name = name {
                arr.append(name)
            }
            if let surname = surname {
                arr.append(surname)
            }
            if let patronym = patronym {
                arr.append(patronym)
            }
            return arr.joined(separator: " ")
        }
    }

}

extension TeacherInfoEntity: ManagedObjectType {

    var identifier: String? {
        return id
    }
}
