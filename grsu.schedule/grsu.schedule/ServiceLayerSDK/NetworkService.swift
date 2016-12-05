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

class NetworkService<T: ModelType> {

    typealias NetworkServiceFetchItemCompletionHandlet = ServiceResult<T, ServiceError> -> ()
    typealias NetworkServiceFetchCompletionHandlet = ServiceResult<[T], ServiceError> -> ()
    typealias NetworkServiceStoreCompletionHandlet = ServiceResult<Void, ServiceError> -> ()

    private let localService: LocalService<T>

    init (localService: LocalService<T>) {

        self.localService = localService
    }

    func fetchDataItem < NetworkServiceQuery: NetworkServiceQueryType where NetworkServiceQuery.QueryInfo == T.QueryInfo > (query: NetworkServiceQuery, cache: CachePolicy, completionHandler: NetworkServiceFetchItemCompletionHandlet) {

        fetchData(query, cache: cache) { (result) in
            
            switch result {
            case .Success(let items):
                guard let item = items.first else {
                    completionHandler(.Failure(.WrongResponseFormat))
                    return
                }
                completionHandler(.Success(item))
            case .Failure(let error):
                completionHandler(.Failure(error))
            }
        }
    }
    
    func fetchData < NetworkServiceQuery: NetworkServiceQueryType where NetworkServiceQuery.QueryInfo == T.QueryInfo > (query: NetworkServiceQuery, cache: CachePolicy, completionHandler: NetworkServiceFetchCompletionHandlet) {

        switch cache {
        case .CachedOnly:

            localService.featch(query, completionHandler: completionHandler)

        case .CachedElseLoad:

            if isCacheExpired(query) {
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
        components.query = query.queryString

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
            self.saveDate(query)
            self.parseAndStore(query, responseDict: responseDict, completionHandler: completionHandler)
        }

        task.resume()
        return task
    }

    private func parseAndStore < NetworkServiceQuery: NetworkServiceQueryType where NetworkServiceQuery.QueryInfo == T.QueryInfo > (query: NetworkServiceQuery, responseDict: [String: AnyObject], completionHandler: NetworkServiceStoreCompletionHandlet) {

        localService.parseAndStore(query, json: responseDict, completionHandler: completionHandler)
    }

    // MARK - Utils

    private func saveDate < NetworkServiceQuery: NetworkServiceQueryType where NetworkServiceQuery.QueryInfo == T.QueryInfo > (query: NetworkServiceQuery) {

        let cacheIdentifier = query.cacheIdentifier
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(NSDate(), forKey: cacheIdentifier)
    }

    private func isCacheExpired < NetworkServiceQuery: NetworkServiceQueryType where NetworkServiceQuery.QueryInfo == T.QueryInfo > (query: NetworkServiceQuery) -> Bool {

        let cacheIdentifier = query.cacheIdentifier
        let userDefaults = NSUserDefaults.standardUserDefaults()

        guard let date = userDefaults.objectForKey(cacheIdentifier) as? NSDate else { return true }
        let expiryDate = date.dateByAddingTimeInterval(query.dynamicType.cacheTimeInterval)

        return expiryDate.compare(NSDate()) == .OrderedAscending
    }

    private func URLSession() -> NSURLSession {
        let queue = NSOperationQueue();
        queue.name = "com.grsu.network.queue"

        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.timeoutIntervalForRequest = 30

        return NSURLSession(configuration: sessionConfig)
    }

}

private extension NetworkServiceQueryType {

    var cacheIdentifier: String {

        var key = String(self.dynamicType)
        if let str = queryString {
            key.appendContentsOf(str)
        }
        return key
    }

    var queryString: String? {
        return parameters?.stringFromHttpParameters()
    }

}

private extension String {
    
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)
    }
    
}

private extension Dictionary {
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joinWithSeparator("&")
    }
    
}
