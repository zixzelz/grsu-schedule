//
//  AuthenticationService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/19/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

typealias AuthenticationCompletionHandlet = ServiceResult<Student, ServiceError> -> Void

class AuthenticationService {

    init() {
    }

    func auth(userName: String, completionHandler: AuthenticationCompletionHandlet) {

//        let userName = "Barsukevich_EA_15"//"Belyvichjs_AR_15"

        let url = NSURL(scheme: UrlScheme, host: UrlHost, path: "/getStudent?login=\(userName)")
        let components = NSURLComponents(URL: url!, resolvingAgainstBaseURL: true)
        let request = NSURLRequest(URL: components!.URL!)

        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)

        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in

            if let error = error {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(.Failure(.NetworkError(error: error)))
                }
                return
            }

            guard let json_ = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers),
                let json = json_ as? [String: AnyObject] else {
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(.Failure(.InternalError))
                    }
                    return
            }

            print("\(json)")

            guard let student = try? Student(json: json) else {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(.Failure(.InternalError))
                }
                return
            }
//            print("1 \(student)")
            dispatch_async(dispatch_get_main_queue()) {
//                print("2 \(student)")
                completionHandler(.Success(student))
            }
        }

        task.resume()
    }
}
