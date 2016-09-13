//
//  NetworkService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/5/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

public enum NetworkServiceMethod: String {
    case GET = "GET"
}

protocol NetworkServiceQueryType: LocalServiceQueryType {

    var path: String { get }
    var method: NetworkServiceMethod { get }
    var parameters: [String: AnyObject]? { get }

    static var cacheTimeInterval: NSTimeInterval { get }
}

extension NetworkServiceQueryType {

    // Think
    static var cacheTimeInterval: NSTimeInterval {
        return 60 * 60 * 24
    }
}

class NetworkService<T: ModelType> {

    typealias NetworkServiceFetchCompletionHandlet = ServiceResult<[T], ServiceError> -> ()
    typealias NetworkServiceStoreCompletionHandlet = ServiceResult<Void, ServiceError> -> ()

    private let localService: LocalService<T>

    init (localService: LocalService<T>) {

        self.localService = localService
    }

    func fetchData < NetworkServiceQuery: NetworkServiceQueryType where NetworkServiceQuery.QueryInfo == T.QueryInfo > (query: NetworkServiceQuery, cache: CachePolicy, completionHandler: NetworkServiceFetchCompletionHandlet) {

        switch cache {
        case .CachedOnly:

            localService.featch(query, completionHandler: completionHandler)

        case .CachedElseLoad:

            if isCacheExpired() {
                resumeRequest(query) { _ in
                    self.localService.featch(query, completionHandler: completionHandler)
                }
            } else {
                localService.featch(query, completionHandler: completionHandler)
            }

        case .ReloadIgnoringCache:

            resumeRequest(query) { _ in
                self.localService.featch(query, completionHandler: completionHandler)
            }
        }

    }

    func resumeRequest < NetworkServiceQuery: NetworkServiceQueryType where NetworkServiceQuery.QueryInfo == T.QueryInfo > (query: NetworkServiceQuery, completionHandler: NetworkServiceStoreCompletionHandlet) -> NSURLSessionDataTask {

        let session = URLSession()
        let url = NSURL(scheme: UrlScheme, host: UrlHost, path: query.path)!
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)!

        if let parameters = query.parameters {
            components.query = configureStringQuery(parameters)
        }

        let request = NSURLRequest(URL: components.URL!)

        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in

            if let error = error {

                NSLog("[Error] response error: \(error)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(.Failure(.NetworkError(error: error)))
                })
                return
            }

            let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
            let responseDict = json as? [String: AnyObject] ?? [String: AnyObject]()

            NSLog("response: %@", NSString(data: data!, encoding: NSUTF8StringEncoding)!)
            self.parseAndStore(query, responseDict: responseDict, completionHandler: completionHandler)
        }

        task.resume()
        return task
    }

    private func parseAndStore < NetworkServiceQuery: NetworkServiceQueryType where NetworkServiceQuery.QueryInfo == T.QueryInfo > (query: NetworkServiceQuery, responseDict: [String: AnyObject], completionHandler: NetworkServiceStoreCompletionHandlet) {

        localService.parseAndStore(query, json: responseDict, completionHandler: completionHandler)
    }

    // MARK - Utils

    private func isCacheExpired() -> Bool {

        let userDefaults = NSUserDefaults.standardUserDefaults()

        guard let date = userDefaults.objectForKey(String(T)) as? NSDate else { return true }
        let expiryDate = date.dateByAddingTimeInterval(60 * 60 * 24)

        return expiryDate.compare(NSDate()) == .OrderedAscending
    }

    private func URLSession() -> NSURLSession {
        let queue = NSOperationQueue();
        queue.name = "com.schedule.queue"

        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.timeoutIntervalForRequest = 30

        return NSURLSession(configuration: sessionConfig)
    }

    private func configureStringQuery(parameters: [String: AnyObject]) -> String {

        let res = parameters.reduce("") { (result, dict) in
            return "\(result)&\(dict.0)=\(dict.1)"
        }
        return res
    }

}
