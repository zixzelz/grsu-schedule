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

    @IBOutlet weak var userLoginTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupEasterEggs()
    }

    @IBAction func loginButtonPressed() {

        guard let login = userLoginTextField.text, !login.isEmpty else {
            showMessage("Поле «Логин» должно быть заполнено")
            return
        }

        MBProgressHUD.showAdded(to: view, animated: true)
        AuthenticationService().auth(login) { [weak self] (result) in
            guard let strongSelf = self else { return }

            MBProgressHUD.hide(for: strongSelf.view, animated: true)

            switch result {
            case .success(let student): strongSelf.authenticationCompleted(student)
            case .failure(_):
                strongSelf.showMessage("Неверное имя пользователя")
            }
        }
    }

    @IBAction func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    fileprivate func authenticationCompleted(_ student: Student) {

        UserDefaults.student = student
        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: Notification.authenticationStateChanged), object: student)

        dismiss(animated: true, completion: nil)
    }

    fileprivate func showMessage(_ title: String) {

        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
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
