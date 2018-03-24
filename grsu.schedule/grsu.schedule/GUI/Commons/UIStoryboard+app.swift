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

    class func authenticationViewController() -> AuthenticationViewController {
        let vc = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "AuthenticationIdentifier") as! AuthenticationViewController
        return vc
    }
    
    class func profileViewController() -> UserProfileViewController {
        let vc = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "ProfileIdentifier") as! UserProfileViewController
        return vc
    }
    
}
