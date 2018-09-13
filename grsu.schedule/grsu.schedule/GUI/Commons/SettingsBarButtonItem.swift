//
//  SettingsBarButtonItem.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/13/18.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit

class SettingsBarButtonItem: UIBarButtonItem {

    override func awakeFromNib() {
        super.awakeFromNib()

        image = UIImage(named: "SettingsIcon")
        title = nil

        target = self
        action = #selector(SettingsBarButtonItem.pressed)
    }

    @objc func pressed() {

        let vc = UIStoryboard.settingsViewController()

        // Think about router
        let window = UIApplication.shared.keyWindow
        if let tbc = window?.rootViewController as? UITabBarController,
            let scv = tbc.selectedViewController as? UISplitViewController {
            scv.toggleMasterView()
        }

        vc.modalPresentationStyle = .formSheet

        window?.rootViewController?.present(vc, animated: true, completion: nil)
    }

}
