//
//  GetDepartmentsService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/14/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class GetDepartmentsService: BaseDataService {
   
    class func getDepartments(completionHandler: ((NSArray?, NSError?) -> Void)!) {
    
        let url = NSURL(scheme: UrlScheme, host: UrlHost, path: "/getDepartments")
        let urlRequest = NSURLRequest(URL: url!)
        
        resumeRequest(urlRequest, completionHandler: { (result: NSDictionary?, error: NSError?) -> Void in
            
            completionHandler(["Den", "Zao"], nil)
        })
    }
    
}
