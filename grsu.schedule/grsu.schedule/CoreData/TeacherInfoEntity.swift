//
//  TeacherInfoEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import Foundation
import ServiceLayerSDK
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

    static func identifier(_ json: NSDictionary) throws -> String {
        guard let id = json["id"] as? String else {
            throw ParseError.invalidData
        }
        return id
    }

    static func objects(_ json: NSDictionary) -> [NSDictionary]? {
        return json.dictArr(for: "items")
    }

    func fill(_ json: NSDictionary, queryInfo: QueryInfo, context: Void) throws {
        let identifier = try DepartmentsEntity.identifier(json)

        updateIfNeeded(keyPath: \TeacherInfoEntity.id, value: identifier)

        if let fullname = json["fullname"] as? String {
            updateIfNeeded(keyPath: \TeacherInfoEntity.title, value: fullname)
        }
        if let _name = json["name"] as? String {
            updateIfNeeded(keyPath: \TeacherInfoEntity.name, value: _name)
        }
        if let _surname = json["surname"] as? String {
            updateIfNeeded(keyPath: \TeacherInfoEntity.surname, value: _surname)
        }
        if let _patronym = json["patronym"] as? String {
            updateIfNeeded(keyPath: \TeacherInfoEntity.patronym, value: _patronym)
        }
        if let _post = json["post"] as? String {
            updateIfNeeded(keyPath: \TeacherInfoEntity.post, value: _post)
        }
        if let _phone = json["phone"] as? String {
            updateIfNeeded(keyPath: \TeacherInfoEntity.phone, value: _phone)
        }
        if let _descr = json["descr"] as? String {
            updateIfNeeded(keyPath: \TeacherInfoEntity.descr, value: _descr)
        }
        if let _email = json["email"] as? String {
            updateIfNeeded(keyPath: \TeacherInfoEntity.email, value: _email)
        }
        if let _skype = json["skype"] as? String {
            updateIfNeeded(keyPath: \TeacherInfoEntity.skype, value: _skype)
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

    static func totalItems(_ json: NSDictionary) -> Int {
        return 0
    }

}

extension TeacherInfoEntity: ManagedObjectType {

    var identifier: String {
        return id
    }
}
