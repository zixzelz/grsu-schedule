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
