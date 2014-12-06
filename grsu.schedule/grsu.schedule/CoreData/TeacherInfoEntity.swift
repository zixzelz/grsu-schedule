//
//  TeacherInfoEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/5/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation
import CoreData

@objc(TeacherInfoEntity)
class TeacherInfoEntity: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var id: String
    @NSManaged var lessons: NSSet

}
