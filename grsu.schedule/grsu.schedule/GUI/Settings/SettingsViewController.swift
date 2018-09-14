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

        doneBarButtonItem.title = L10n.done
        navigationItem.title = L10n.settingsNavigationBarTitle
        languageLabel.text = L10n.settingsLanguageMenuItemTitle
        languageValueLabel.text = ""

        setup()
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
