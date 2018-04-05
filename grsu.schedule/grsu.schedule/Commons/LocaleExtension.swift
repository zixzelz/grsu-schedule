//
//  NSLocalExtension.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 4/2/18.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit

extension Locale {

    private struct Constants {
        static let defaultLocale = "en_GB"
        static let defaultLanguageCode = "en"
    }

    static var preferredLanguageCode: String {
        guard let languageCode = Locale.current.languageCode else {
            return Constants.defaultLanguageCode
        }

        switch languageCode {
        case "be",  "ru":
            return languageCode
        default:
            return Constants.defaultLanguageCode
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
