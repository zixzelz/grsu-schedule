//
//  UIDevice+type.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 3/26/18.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit

extension UIDevice {
    class var isIPAD: Bool {
        return current.userInterfaceIdiom == .pad
    }
}
