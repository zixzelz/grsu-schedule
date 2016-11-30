//
//  BaseDataService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/14/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

enum ServiceResult<T, Error: ErrorType> {

    case Success(T)
    case Failure(Error)
}

typealias ResumeRequestCompletionHandlet = ServiceResult<[String: AnyObject], NSError> -> ()

class BaseDataService: NSObject {

    class func resumeRequest(path: String, queryItems: String?, completionHandler: ResumeRequestCompletionHandlet) -> NSURLSessionDataTask {
        let session = URLSession()

        let url = NSURL(scheme: UrlScheme, host: UrlHost, path: path)
        let components = NSURLComponents(URL: url!, resolvingAgainstBaseURL: true)
        components?.query = queryItems

        let request = NSURLRequest(URL: components!.URL!)

        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in

            if let error = error {

                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(.Failure(error))
                })
                return
            }

            let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
            let responseDict = json as? [String: AnyObject] ?? [String: AnyObject]()

            NSLog("response: %@", NSString(data: data!, encoding: NSUTF8StringEncoding)!)

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(.Success(responseDict))
            })
        }

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
