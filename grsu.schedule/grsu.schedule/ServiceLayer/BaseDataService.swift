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
   
    class func resumeRequest(path: String, queryItems: [AnyObject]?, completionHandler: ((NSDictionary?, NSError?) -> Void)!) -> NSURLSessionDataTask {
        let session = URLSession()
        
        let url = NSURL(scheme: UrlScheme, host: UrlHost, path: path)
        let components = NSURLComponents(URL: url!, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        
        let request = NSURLRequest(URL: components!.URL!)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(nil, nil)
            })
        })
        
        task.resume()
        return task
    }
    
    
    class func URLSession() -> NSURLSession {
        let queue = NSOperationQueue();
        queue.name = "com.schedule.queue"
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.timeoutIntervalForRequest = 30
        
        return NSURLSession(configuration: sessionConfig)
    }
    
}
