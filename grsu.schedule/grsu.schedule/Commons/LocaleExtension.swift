//
//  NSLocalExtension.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 4/2/18.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit

enum LanguageItem: String {
    case ru = "ru"
    case en = "en"
    case be = "be"

    var code: String {
        return rawValue
    }

    var title: String {
        switch self {
        case .ru:
            return "ru"
        case .en:
            return "en"
        case .be:
            return "be"
        }
    }

    static var defaultValue: LanguageItem {
        return .en
    }
}

extension Locale {

    private struct Constants {
        static let defaultLocale = "en_GB"
    }

    static var languages: [LanguageItem] {
        return [.ru, .en, .be]
    }

    static var preferredLanguageCode: String {
        let languageCode = UserDefaults.selectedLanguage.code

        switch languageCode {
        case "be", "ru":
            return languageCode
        default:
            return LanguageItem.defaultValue.code
        }
    }

    static var preferredLocale: String {
        let code = preferredLanguageCode

        var locale: String?
        switch code {
        case "en":
            locale = "\(code)_GB"
        case "be":
            locale = "\(code)_BY"
        case "ru":
            locale = "\(code)_RU"
        default:
            if let regionCode = Locale.current.regionCode {
                locale = "\(code)_\(regionCode)"
            }
        }

        return locale ?? Constants.defaultLocale
    }

}
