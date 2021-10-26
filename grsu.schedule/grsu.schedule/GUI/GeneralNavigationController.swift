//
//  GeneralNavigationController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 26.10.21.
//  Copyright © 2021 Ruslan Maslouski. All rights reserved.
//

import UIKit

class GeneralNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyle()
    }

}

extension UINavigationController {
    func applyStyle() {
        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Asset.Colors.navigationBarColor.color
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
