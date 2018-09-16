//
//  SettingsViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/13/18.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit
import ReactiveSwift

class SettingsViewController: UITableViewController {

    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageValueLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        languageValueLabel.text = ""

        setup()
        setupLanguage()
    }

    private var scopedDisposable: ScopedDisposable<AnyDisposable>?
    private func setup() {
        let list = CompositeDisposable()
        scopedDisposable = ScopedDisposable(list)

        list += UserDefaults.selectedLanguageSignalProducer
            .skipRepeats()
            .startWithValues { [unowned self] language in
                self.languageValueLabel.text = language.title
        }
    }

    private func setupLanguage() {
        languageLabel.setLocalizedTitle(L10n.settingsLanguageMenuItemTitle)
        doneBarButtonItem.setLocalizedTitle(L10n.done)
        navigationItem.setLocalizedTitle(L10n.settingsNavigationBarTitle)
//        UserDefaults.selectedLanguageSignalProducer
//            .skipRepeats()
//            .take(duringLifetimeOf: self)
//            .startWithValues { [unowned self] _ in
//                self.navigationItem.title = L10n.settingsNavigationBarTitle
//        }
    }

    @IBAction func donePressed() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LanguageSelectionIdentifier", let vc: LanguageSelectionViewController = segue.viewController() {
            let language = UserDefaults.selectedLanguage
            vc.viewModel = LanguageSelectionViewModel(defaultLanguage: language)
        }
    }

}
