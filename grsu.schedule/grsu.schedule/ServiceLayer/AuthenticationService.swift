//
//  AuthenticationService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/19/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

typealias AuthenticationCompletionHandlet = ServiceResult<[FacultiesEntity], ServiceError> -> Void

class AuthenticationService {

    init() {
    }

    func auth(userName: String, completionHandler: FacultyCompletionHandlet) {

        let userName = "Belyvichjs_AR_15"

        let url = NSURL(scheme: UrlScheme, host: UrlHost, path: "/getStudent?login=\(userName)")
        let components = NSURLComponents(URL: url!, resolvingAgainstBaseURL: true)
        let request = NSURLRequest(URL: components!.URL!)

        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)

        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
            print("\(json)")
        }

        task.resume()
    }
}
