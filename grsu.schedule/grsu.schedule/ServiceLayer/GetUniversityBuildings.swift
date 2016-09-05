//
//  GetUniversityBuildings.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/26/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class GetUniversityBuildings: BaseDataService {

    class func getBuildings(completionHandler: (([UniversityBuilding]?, NSError?) -> Void)!) {
        featchBuildings(completionHandler)
    }
    

    private class func featchBuildings(completionHandler: (([UniversityBuilding]?, NSError?) -> Void)!) {
        
        let filePath = NSBundle.mainBundle().pathForResource("UniversityBuildings", ofType:"json")
        let data = NSData(contentsOfFile:filePath!)
        
        var responseArray : NSArray?
        responseArray = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSArray

        
        var universityBuilding = [UniversityBuilding]()
        
        for buildingDict in responseArray! {
            
            var building: UniversityBuilding!
            
            let type = buildingDict["type"] as? String
            if type == "Educational" {
                
                var faculties = [FacultyOfUniversity]()
                for facultyDict in buildingDict["faculties"] as! NSArray {
                    
                    let faculty = FacultyOfUniversity()
                    faculty.title = facultyDict["title"] as? String
                    faculty.site = facultyDict["site"] as? String
                    
                    faculties.append(faculty)
                }
                
                let educational = EducationalUniversityBuilding()
                educational.faculties = faculties
                
                building = educational
            } else if type == "Hostel" {
                let hostel = HostelUniversityBuilding()
                hostel.title = buildingDict["title"] as? String
                hostel.number = buildingDict["number"] as? String
                
                building = hostel
            }
            
            let location = CLLocationCoordinate2D(latitude: (buildingDict["lat"] as! NSString ).doubleValue, longitude: (buildingDict["lng"] as! NSString ).doubleValue)
            
            building.photo = buildingDict["photo"] as? String
            building.address = buildingDict["address"] as? String
            building.location = location
            
            universityBuilding.append(building!)
        }
        
        completionHandler(universityBuilding, nil)
    }
    
}
