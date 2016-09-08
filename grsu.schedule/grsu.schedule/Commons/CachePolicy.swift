//
//  CachePolicy.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/5/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

enum CachePolicy {
    case CachedOnly
//    case CachedThenLoad
    case CachedElseLoad
    case ReloadIgnoringCache
}
