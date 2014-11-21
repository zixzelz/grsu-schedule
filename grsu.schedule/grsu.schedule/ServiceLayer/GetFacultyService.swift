//
//  GetFacultyService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/21/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class GetFacultyService: BaseDataService {

    class func getFaculties(completionHandler: ((Array<GSItem>?, NSError?) -> Void)!) {
        
        let path = "/getFaculties"
        
        resumeRequest(path, queryItems: nil, completionHandler: { (result: NSDictionary?, error: NSError?) -> Void in
            
            completionHandler([GSItem("0", "Инженерно-строительный факульт"), GSItem("0", "Факультет биологии и экологии"), GSItem("0", "Факультет истории коммуникации и туризма")], nil)
        })
    }
    
}
