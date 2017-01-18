//
//  FlurryExpanded.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/18/17.
//  Copyright © 2017 Ruslan Maslouski. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

extension Flurry {

    class func logError(error: ServiceError, errId: String) {
        
        var err: NSError?
        var message: String
        
        switch error {
        case .NetworkError(let error):
            err = error
            message = "NetworkError"
        case .WrongResponseFormat:
            message = "WrongResponseFormat"
        case .InternalError:
            message = "InternalError"
        }
        
        logError(errId, message: message, error: err)
    }
}
