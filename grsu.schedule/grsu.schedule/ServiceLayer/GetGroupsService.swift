//
//  GetGroupsService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/21/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class GetGroupsService: BaseDataService {

    class func getGroups(facultyId: String, departmantId: String, course: String, completionHandler: ((Array<GSItem>?, NSError?) -> Void)!) {
        
        let path = "/getGroups"
        
        let queryItems = [
            NSURLQueryItem(name: "facultyId", value: facultyId),
            NSURLQueryItem(name: "departmantId", value: departmantId),
            NSURLQueryItem(name: "course", value: course),
        ]
        
        resumeRequest(path, queryItems: queryItems, completionHandler: { (result: NSDictionary?, error: NSError?) -> Void in
            completionHandler([GSItem("0", "СДП-МАТ(НПД)-141"), GSItem("0", "СДП-ПОИТ-141"), GSItem("0", "СДП-УИР-141")], nil)
        })
    }
}
