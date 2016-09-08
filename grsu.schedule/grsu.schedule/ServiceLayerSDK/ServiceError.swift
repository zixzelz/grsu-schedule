//
//  ServiceError.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/9/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

enum ServiceError: ErrorType {

    case NetworkError(error: NSError)
    case WrongResponseFormat
}
