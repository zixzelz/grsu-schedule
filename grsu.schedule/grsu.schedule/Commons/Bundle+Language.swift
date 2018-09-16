//
//  Bundle+Language.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/14/18.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let languageDidChanged = Notification.Name("languageDidChanged")
}

private var currentLanguageBundle: Bundle?

extension Bundle {

    private struct Constant {
        static let defaultLanguageCode = "en"
    }

    static var languageBundle: Bundle {
        return currentLanguageBundle ?? defaultLanguageBundle()
    }

    static func setLanguage(code: String) {
        currentLanguageBundle = languageBundle(code: code)
        NotificationCenter.default.post(name: .languageDidChanged, object: nil)
    }

    fileprivate static func defaultString(key: String) -> String {
        return defaultLanguageBundle().localizedString(forKey: key, value: key, table: nil)
    }

    private static func defaultLanguageBundle() -> Bundle {
        return languageBundle(code: Constant.defaultLanguageCode)!
    }

    private static func languageBundle(code: String) -> Bundle? {
        guard let path = Bundle.main.path(forResource: code, ofType: "lproj") else {
            return nil
        }
        return Bundle(path: path)
    }

}

func locString(key: String) -> String {
    let value = Bundle.defaultString(key: key)
    return Bundle.languageBundle.localizedString(forKey: key, value: value, table: nil)
}
