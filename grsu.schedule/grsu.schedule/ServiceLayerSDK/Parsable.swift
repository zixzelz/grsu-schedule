//
//  Parsable.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/6/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

protocol Parsable: class {

    associatedtype QueryInfo: QueryInfoType

    static func keyForIdentifier() -> String
    static func keyForEnumerateObjects() -> String

    func fill(json: [String: AnyObject], queryInfo: QueryInfo)
    func update(json: [String: AnyObject], queryInfo: QueryInfo)
}
