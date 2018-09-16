//
//  AuthenticationViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/22/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit
import MBProgressHUD

class AuthenticationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private weak var userLoginTextField: UITextField!
    @IBOutlet private weak var userLoginButton: UIButton!
//    @IBOutlet private weak var userBackButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupEasterEggs()

        userLoginTextField.placeholder = L10n.authenticationFieldLogin
        userLoginButton.setTitle(L10n.authenticationActionLogin, for: .normal)
//        userBackButton.setTitle(L10n.anyScreenActionBack, for: .normal)
    }

    @IBAction func loginButtonPressed() {

        guard let login = userLoginTextField.text, !login.isEmpty else {
            showMessage(L10n.usernameCannotBeEmptyMessage)
            return
        }

        MBProgressHUD.showAdded(to: view, animated: true)
        AuthenticationService().auth(login) { [weak self] (result) in
            guard let strongSelf = self else { return }

            MBProgressHUD.hide(for: strongSelf.view, animated: true)

            switch result {
            case .success(let student): strongSelf.authenticationCompleted(student)
            case .failure(_):
                strongSelf.showMessage(L10n.usernameNotFoundHeader, message: L10n.usernameNotFoundMessage)
            }
        }
    }

    @IBAction func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    fileprivate func authenticationCompleted(_ student: Student) {

        UserDefaults.student = student
        NotificationCenter.default.post(name: .authenticationStateChanged, object: student)

        dismiss(animated: true, completion: nil)
    }

    fileprivate func showMessage(_ title: String, message: String? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    //MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        if userLoginTextField.text != "" {
            loginButtonPressed()
        }

        return true
    }

    // MARK: - Easter egg

    @IBOutlet weak var easterEggsPrivateView: UIView!

    fileprivate func setupEasterEggs() {
        let firstGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(AuthenticationViewController.longtapGestureRecognizer(_:)))
        firstGestureRecognizer.minimumPressDuration = 0.5
        easterEggsPrivateView.addGestureRecognizer(firstGestureRecognizer)
    }

    var startPoint = CGPoint.zero
    @objc fileprivate func longtapGestureRecognizer(_ sender: UILongPressGestureRecognizer) {
        switch (sender.state) {
        case .began: startPoint = sender.location(in: sender.view)
        case .ended:
            let point = sender.location(in: sender.view)
            if (startPoint.x >= point.x + 100) {
                showEasterEgg()
            } else {
                easterEggsPrivateView.removeGestureRecognizer(sender)
            }
        default: break
        }
    }

    fileprivate func showEasterEgg() {
        userLoginTextField.text = "Barsukevich_EA_15"
    }
}
