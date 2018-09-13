//
//  UserDefaults.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/28/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

extension UserDefaults {

    fileprivate static var userDefaults: UserDefaults {
        return standard
    }

    static var student: Student? {
        set {
            guard let value = newValue else {
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

    static var previousLanguageCode: String? {
        set {
            guard let value = newValue else {
                userDefaults.removeObject(forKey: "previousLanguageCode")
                return
            }
            userDefaults.set(value, forKey: "previousLanguageCode")
        }
        get {
            return userDefaults.string(forKey: "previousLanguageCode")
        }
    }

    static var selectedLanguage: LanguageItem {
        set {
            userDefaults.set(newValue.code, forKey: "selectedLanguageCode")
        }
        get {
            let code = userDefaults.string(forKey: "selectedLanguageCode")
            return code.flatMap { LanguageItem(rawValue: $0) } ?? .defaultValue
        }
    }

    static var selectedLanguageSignalProducer: SignalProducer<LanguageItem, NoError> {
        return userDefaults.reactive.producer(forKeyPath: "selectedLanguageCode").map { value in
            let code = userDefaults.string(forKey: "selectedLanguageCode")
            return code.flatMap { LanguageItem(rawValue: $0) } ?? .defaultValue
        }.skipRepeats()
    }

}
