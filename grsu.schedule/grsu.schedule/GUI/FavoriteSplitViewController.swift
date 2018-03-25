//
//  FavoriteSplitViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 3/26/18.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit

class FavoriteSplitViewController: GeneralSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredDisplayMode = .automatic
    }

    override func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        return .automatic
    }

}
