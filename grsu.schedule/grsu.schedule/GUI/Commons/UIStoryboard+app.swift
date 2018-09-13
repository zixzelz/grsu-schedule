//
//  app.swift
//  Intuition
//
//  Created by Ruslan Maslouski on 5/10/15.
//  Copyright (c) 2015 Intuition inc. All rights reserved.
//

import UIKit

extension UIStoryboard {

    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    class func supportStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "SupportStoryboard", bundle: nil)
    }

    class func authenticationViewController() -> AuthenticationViewController {
        let vc = UIStoryboard.supportStoryboard().instantiateViewController(withIdentifier: "AuthenticationIdentifier") as! AuthenticationViewController
        return vc
    }

    class func profileViewController() -> UserProfileViewController {
        let vc = UIStoryboard.supportStoryboard().instantiateViewController(withIdentifier: "ProfileIdentifier") as! UserProfileViewController
        return vc
    }

    class func dedaultDetailSplitViewContrioller() -> UIViewController {
        let vc = UIStoryboard.supportStoryboard().instantiateViewController(withIdentifier: "DedaultDetailSplitIdentifier")
        return vc
    }

    class func settingsViewController() -> UIViewController {
        let vc = UIStoryboard.supportStoryboard().instantiateViewController(withIdentifier: "SettingsIdentifier")
        return vc
    }

}

extension UIStoryboardSegue {

    func viewController<T: UIViewController>() -> T? {
        if let vc = destination as? T {
            return vc
        } else if let nc = destination as? UINavigationController, let vc = nc.viewControllers.first as? T {
            return vc
        }

        return nil
    }

}
