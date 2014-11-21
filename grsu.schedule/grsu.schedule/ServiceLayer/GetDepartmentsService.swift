//
//  GetDepartmentsService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/14/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class GetDepartmentsService: BaseDataService {
   
    class func getDepartments(completionHandler: ((Array<GSItem>?, NSError?) -> Void)!) {
        let path = "/getDepartments"
        
        resumeRequest(path, queryItems: nil, completionHandler: { (result: NSDictionary?, error: NSError?) -> Void in
            
            completionHandler([GSItem("0", "Den"), GSItem("0", "Zao")], nil)
        })
    }
    
}
