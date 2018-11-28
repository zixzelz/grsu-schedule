//
//  LocalizationHelper.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/14/18.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit
import ReactiveSwift
import RAMAnimatedTabBarController

extension UITabBarItem {
    func setLocalizedTitle(_ value: @escaping @autoclosure () -> String) {
        guard let item = self as? RAMAnimatedTabBarItem else {
            return
        }
        
        let signal = NotificationCenter.default.reactive.notifications(forName: .languageDidChanged).map { _ -> String in
            return value()
        }
        let property = Property<String?>(initial: value(), then: signal)

        property.producer
            .take(duringLifetimeOf: self)
            .startWithValues { text in
            item.iconView?.textLabel.text = text
        }
    }
}

extension UILabel {
    func setLocalizedTitle(_ value: @escaping @autoclosure () -> String) {
        let signal = NotificationCenter.default.reactive.notifications(forName: .languageDidChanged).map { _ -> String in
            return value()
        }
        let property = Property<String?>(initial: value(), then: signal)
        reactive.text <~ property
    }
}

extension UIBarButtonItem {

    public convenience init(localizedTitle: @escaping @autoclosure () -> String, style: UIBarButtonItemStyle, target: Any?, action: Selector?) {
        self.init(title: nil, style: style, target: target, action: action)
        setLocalizedTitle(localizedTitle)
    }

    typealias LocalizedBlock = () -> String?
    func setLocalizedTitle(_ value: @escaping @autoclosure  () -> String) {
        let signal = NotificationCenter.default.reactive.notifications(forName: .languageDidChanged).map { _ -> String? in
            return value()
        }
        let property = Property<String?>(initial: value(), then: signal)
        reactive.title <~ property
    }
}

extension UINavigationItem {
    func setLocalizedTitle(_ value: @escaping @autoclosure () -> String) {
        let signal = NotificationCenter.default.reactive.notifications(forName: .languageDidChanged).map { _ -> String in
            return value()
        }
        let property = Property<String?>(initial: value(), then: signal)
        reactive.title <~ property
    }
}

extension UIButton {
    func setLocalizedTitle(_ value: @escaping @autoclosure () -> String) {
        let signal = NotificationCenter.default.reactive.notifications(forName: .languageDidChanged).map { _ -> String in
            return value()
        }
        let property = Property<String>(initial: value(), then: signal)
        reactive.title <~ property
    }
}

extension UISearchBar {
    func setLocalizedPlaceholder(_ value: @escaping @autoclosure () -> String) {
        let signal = NotificationCenter.default.reactive.notifications(forName: .languageDidChanged).map { _ -> String in
            return value()
        }
        let property = Property<String?>(initial: value(), then: signal)
        reactive.placeholder <~ property
    }
}

extension Reactive where Base: UISearchBar {

    /// Sets the text of the search bar.
    public var placeholder: BindingTarget<String?> {
        return makeBindingTarget { $0.placeholder = $1 }
    }
}
