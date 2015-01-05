//
//  DayScheduleEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import Foundation
import CoreData

@objc(DayScheduleEntity)
class DayScheduleEntity: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var lessons: NSOrderedSet

}
