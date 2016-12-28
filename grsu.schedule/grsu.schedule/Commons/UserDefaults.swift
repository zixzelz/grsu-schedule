//
//  UserDefaults.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/28/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

extension NSUserDefaults {

    private static var userDefaults: NSUserDefaults {
        return standardUserDefaults()
    }

    static var student: Student? {
        set {
            guard let value = newValue else  {
                userDefaults.removeObjectForKey("student")
                return
            }
            let data = NSKeyedArchiver.archivedDataWithRootObject(value)
            userDefaults.setObject(data, forKey: "student")
        }
        get {
            guard let data = userDefaults.objectForKey("student") as? NSData else { return nil }
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Student
        }
    }

}
