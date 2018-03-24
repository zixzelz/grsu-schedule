//
//  UserDefaults.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/28/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

extension UserDefaults {

    fileprivate static var userDefaults: UserDefaults {
        return standard
    }

    static var student: Student? {
        set {
            guard let value = newValue else  {
                userDefaults.removeObject(forKey: "student")
                return
            }
            let data = NSKeyedArchiver.archivedData(withRootObject: value)
            userDefaults.set(data, forKey: "student")
        }
        get {
            guard let data = userDefaults.object(forKey: "student") as? Data else { return nil }
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? Student
        }
    }

}
