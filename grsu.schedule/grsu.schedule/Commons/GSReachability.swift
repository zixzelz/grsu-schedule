//
//  GSReachability.swift
//  grsu.schedule
//
//  Created by Ruslan on 27.01.15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

class GSReachability: Reachability {

    static let sharedInstance: GSReachability = GSReachability(hostName: ReachabilityURL)

    // MARK: Reachability

    func isHostAvailable() -> Bool {

        return currentReachabilityStatus() != NotReachable
    }

}
