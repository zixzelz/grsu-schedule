//
//  AuthenticationService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/19/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import Foundation

typealias AuthenticationCompletionHandlet = (ServiceResult<Student, ServiceError>) -> Void

class AuthenticationService {

    init() {
    }

    func auth(_ userName: String, completionHandler: @escaping AuthenticationCompletionHandlet) {

//        let userName = "Barsukevich_EA_15"//"Belyvichjs_AR_15"
        let components = URLComponents(string: UrlHost + "/getStudent?login=\(userName)&\(Parametres.lang.rawValue)=\(Locale.preferredLocale)")
        let request = URLRequest(url: components!.url!)

        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)

        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(.networkError(error: error)))
                }
                return
            }

            guard let json_ = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers),
                let json = json_ as? [String: AnyObject] else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(.internalError))
                    }
                    return
            }

            #if DEBUG
                print("\(json)")
            #endif

            guard let student = Student(json: json) else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.internalError))
                }
                return
            }
//            print("1 \(student)")
            DispatchQueue.main.async {
//                print("2 \(student)")
                completionHandler(.success(student))
            }
        }

        task.resume()
    }
}
