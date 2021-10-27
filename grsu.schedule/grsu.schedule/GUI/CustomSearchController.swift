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
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]

        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = .red
            if let leftView = textfield.leftView as? UIImageView {
//                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.white.withAlphaComponent(0.8)
            }
        }

        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {

                backgroundview.backgroundColor = UIColor.red

                backgroundview.layer.cornerRadius = 30
                backgroundview.clipsToBounds = true
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard #available(iOS 15.0, *) else {
            if let presentingVC = presentingViewController {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.view.frame = presentingVC.view.frame
                }
            }
            return
        }
    }

}
