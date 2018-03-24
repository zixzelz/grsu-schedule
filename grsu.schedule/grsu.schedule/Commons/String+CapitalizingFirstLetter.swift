//
//  String+CapitalizingFirstLetter.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/30/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
