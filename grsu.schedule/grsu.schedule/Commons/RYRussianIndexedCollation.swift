//
//  RYRussianIndexedCollation.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 5/22/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

let DefaultCollection: [Character] = ["А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ы", "Э", "Ю", "Я", "#"]

class RYRussianIndexedCollation {

    var sectionTitles = DefaultCollection
    var sectionIndexTitles = DefaultCollection

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
