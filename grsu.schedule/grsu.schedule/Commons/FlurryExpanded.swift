//
//  FlurryExpanded.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/18/17.
//  Copyright © 2017 Ruslan Maslouski. All rights reserved.
//

import UIKit
import ServiceLayerSDK
import Flurry_iOS_SDK

extension Flurry {

    class func logError(_ error: ServiceError, errId: String) {
        
        var err: Error?
        var message: String
        
        switch error {
        case .networkError(let error):
            err = error
            message = "NetworkError"
        case .wrongResponseFormat:
            message = "WrongResponseFormat"
        case .internalError:
            message = "InternalError"
        }
        
        logError(errId, message: message, error: err)
    }
}
