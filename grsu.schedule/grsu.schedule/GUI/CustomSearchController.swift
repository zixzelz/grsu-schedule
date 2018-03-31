//
//  CustomSearchController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 3/31/18.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit

class CustomSearchController: UISearchController {

    required override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        setup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        searchBar.tintColor = .white
        searchBar.barTintColor = UIColor.navigationBar.withAlphaComponent(0.85)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.navigationBar

        if #available(iOS 11.0, *) {

            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
//                textfield.textColor = UIColor.blue
                if let backgroundview = textfield.subviews.first {

                    backgroundview.backgroundColor = UIColor.white

                    backgroundview.layer.cornerRadius = 10
                    backgroundview.clipsToBounds = true
                }
            }
        }
    }

}
