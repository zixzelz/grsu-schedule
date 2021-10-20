//
//  UILabel+SetText.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 19.10.21.
//  Copyright © 2021 Ruslan Maslouski. All rights reserved.
//

import UIKit

extension UILabel {
    func setTextOrHide(_ text: String?) {
        self.text = text
        self.isHidden = text.isNilOrEmpty
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return (self ?? "").isEmpty
    }
}
