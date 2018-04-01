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
        static let defaultLocale = "ru_RU"
    }

    static var currenLocale: String {
        guard let code = Locale.current.languageCode else {
            return Constants.defaultLocale
        }

        var locale: String?
        switch code {
        case "en":
            return "\(code)_GB"
        case "be":
            return "\(code)_BY"
        case "ru":
            return "\(code)_RU"
        default:
            if let regionCode = Locale.current.regionCode {
                locale = "\(code)_\(regionCode)"
            }
        }

        return locale ?? Constants.defaultLocale
    }

}
