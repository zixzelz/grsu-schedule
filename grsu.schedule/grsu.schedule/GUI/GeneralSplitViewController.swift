//
//  GeneralSplitViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 3/25/18.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit

protocol SecondarySplitViewControllerProtocol {
    func shouldCollapsed() -> Bool
}

class GeneralSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

//        guard
//            let navigationController = viewControllers[viewControllers.count - 1] as? UINavigationController,
//            let navigationItem = navigationController.topViewController?.navigationItem else {
//                return
//        }
//
//        navigationItem.leftBarButtonItem = displayModeButtonItem

        preferredDisplayMode = .allVisible
        showDetailViewController(defaultDetailVC(), sender: nil)
    }

    private func defaultDetailVC() -> UIViewController {
        return UIStoryboard.dedaultDetailSplitViewContrioller()
    }
}

extension GeneralSplitViewController: UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard
            let secondaryAsNavController = secondaryViewController as? UINavigationController,
            let topAsDetailController = secondaryAsNavController.topViewController as? SecondarySplitViewControllerProtocol else {
                return true
        }
        return topAsDetailController.shouldCollapsed()
    }

    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        guard
            let navigationController = vc as? UINavigationController,
            let navigationItem = navigationController.topViewController?.navigationItem else {
                return false
        }

        navigationItem.leftBarButtonItem = displayModeButtonItem
//        navigationItem.leftItemsSupplementBackButton = true

        toggleMasterView()
        return false
    }

    func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        return .allVisible
    }
}

extension UISplitViewController {
    func toggleMasterView() {
        let barButtonItem = displayModeButtonItem
        if let action = barButtonItem.action {
            _ = UIApplication.shared.sendAction(action, to: barButtonItem.target, from: nil, for: nil)
        }
    }
}
