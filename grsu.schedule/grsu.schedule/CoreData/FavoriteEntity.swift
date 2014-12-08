//
//  FavoriteEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/7/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation
import CoreData

@objc(FavoriteEntity)
class FavoriteEntity: NSManagedObject {

    @NSManaged var synchronizeCalendar: NSNumber
    @NSManaged var group: GroupsEntity

}
