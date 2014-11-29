//
//  FacultiesEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/29/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation
import CoreData

class FacultiesEntity: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var id: String

}
