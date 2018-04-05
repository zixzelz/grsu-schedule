//
//  RYRussianIndexedCollation.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 5/22/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

private struct DefaultCollection {
    static let ru: [Character] = ["А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ы", "Э", "Ю", "Я", "#"]
    static let en: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]

    static var current: [Character] {
        return Locale.preferredLanguageCode == "en" ? DefaultCollection.en : DefaultCollection.ru
    }
}

class RYRussianIndexedCollation {

    var sectionTitles: [Character] {
        return DefaultCollection.current
    }

    var sectionIndexTitles: [Character] {
        return DefaultCollection.current
    }

    func sectionForSectionIndexTitleAtIndex(_ indexTitleIndex: Int) -> Int {
        return indexTitleIndex
    }

    func sectionForObject(_ object: String?) -> Int {

        var sectionIndex: Int = sectionTitles.count - 1
        if let object = object {

            let firstChar = object.capitalized[object.startIndex]
            if let val = sectionTitles.index(of: firstChar) {

                sectionIndex = val
            }
        }

        return sectionIndex
    }
}
