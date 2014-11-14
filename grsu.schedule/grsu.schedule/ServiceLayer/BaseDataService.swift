//
//  BaseDataService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/14/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

let UrlScheme = "http"
let UrlHost = "api.grsu.by/1.x/app1"

class BaseDataService: NSObject {
   
    class func resumeRequest(request: NSURLRequest!, completionHandler: ((NSDictionary?, NSError?) -> Void)!) -> NSURLSessionDataTask {
        let queue = NSOperationQueue();
        queue.name = "com.schedule.queue"
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.timeoutIntervalForRequest = 30
        
        let session = NSURLSession(configuration: sessionConfig)
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(nil, nil)
            })
        })
        
        task.resume()
        return task
    }
    
}
