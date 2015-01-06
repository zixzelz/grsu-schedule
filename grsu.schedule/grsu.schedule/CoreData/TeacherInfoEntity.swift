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
    @NSManaged var updatedDate: NSDate
    @NSManaged var lessons: NSSet
    @NSManaged var favorite: FavoriteEntity

}
