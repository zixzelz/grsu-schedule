//
//  UniversityBuilding.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/26/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreLocation

class UniversityBuilding: NSObject {

    var photo : String?
    var address : String?
    var location : CLLocationCoordinate2D?
}

class EducationalUniversityBuilding: UniversityBuilding {
    
    var faculties : [FacultyOfUniversity]?
    
}

class HostelUniversityBuilding: UniversityBuilding {
    
    var title : String?
    var number : String?
    
}
