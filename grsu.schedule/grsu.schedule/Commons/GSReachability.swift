//
//  GSReachability.swift
//  grsu.schedule
//
//  Created by Ruslan on 27.01.15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

class GSReachability: Reachability {
    
    class var sharedInstance: GSReachability {
        struct Static {
            static var instance: GSReachability?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = GSReachability(hostName: ReachabilityURL)
        }
        
        return Static.instance!
    }
    
    // MARK: Reachability
    
    func isHostAvailable() -> Bool {
        if ( self.currentReachabilityStatus().value == NotReachable.value) {
            return false;
        }
        return true;
    }

}
