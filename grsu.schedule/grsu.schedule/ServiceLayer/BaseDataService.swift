//
//  BaseDataService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/14/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation
import ServiceLayerSDK

//enum ServiceResult<T, Err: Error> {
//
//    case success(T)
//    case failure(Err)
//}

typealias ResumeRequestCompletionHandlet = (ServiceResult<[String: AnyObject], ServiceError>) -> ()

class BaseDataService: NSObject {

    class func resumeRequest(_ path: String, queryItems: String?, completionHandler: @escaping ResumeRequestCompletionHandlet) -> URLSessionDataTask {
        let session = urlSession()

        var components = URLComponents(string: UrlHost + path)
        components?.query = queryItems

        let request = URLRequest(url: components!.url!)

        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

            if let error = error {

                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(.failure(.networkError(error: error)))
                })
                return
            }

            let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            let responseDict = json as? [String: AnyObject] ?? [String: AnyObject]()

            NSLog("response: %@", NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)

            DispatchQueue.main.async(execute: { () -> Void in
                completionHandler(.success(responseDict))
            })
        }

        task.resume()
        return task
    }

    class func urlSession() -> Foundation.URLSession {
        let queue = OperationQueue()
        queue.name = "com.schedule.queue"

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30

        return URLSession(configuration: sessionConfig)
    }

}
