//
//  Parsable.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/6/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

protocol Parsable: class {

    static func keyForIdentifier() -> String
    static func keyForEnumerateObjects() -> String

    func fill(json: [String: AnyObject])
}

protocol ModelType: Parsable, ManagedObjectType {

}
