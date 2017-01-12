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

        guard let login = userLoginTextField.text where !login.isEmpty else {
            showMessage("Поле «Логин» должно быть заполнено")
            return
        }

        MBProgressHUD.showHUDAddedTo(view, animated: true)
        AuthenticationService().auth(login) { [weak self] (result)  in
            guard let strongSelf = self else {return}
            
            MBProgressHUD.hideHUDForView(strongSelf.view, animated: true)

            switch result {
            case.Success(let student): strongSelf.authenticationCompleted(student)
            case .Failure(_): strongSelf.showMessage("Неверное имя пользователя")
            }
        }
    }

    @IBAction func cancelButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    private func authenticationCompleted(student: Student) {
        
        NSUserDefaults.student = student
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.authenticationStateChanged, object: student)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func showMessage(title: String) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)

        if userLoginTextField.text != "" {
            loginButtonPressed()
        }

        return true;
    }
    
    // MARK: - Easter egg
    
    @IBOutlet weak var easterEggsPrivateView: UIView!
    
    private func setupEasterEggs() {
        let firstGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(AuthenticationViewController.longtapGestureRecognizer(_:)))
        firstGestureRecognizer.minimumPressDuration = 0.5
        easterEggsPrivateView.addGestureRecognizer(firstGestureRecognizer)
    }
    
    var startPoint = CGPointZero
    @objc private func longtapGestureRecognizer(sender: UILongPressGestureRecognizer) {
        switch (sender.state) {
        case .Began: startPoint = sender.locationInView(sender.view)
        case .Ended:
            let point = sender.locationInView(sender.view)
            if (startPoint.x >= point.x + 100) {
                showEasterEgg()
            } else {
                easterEggsPrivateView.removeGestureRecognizer(sender)
            }
        default: break;
        }
    }
    
    private func showEasterEgg() {
        userLoginTextField.text = "Barsukevich_EA_15"
    }
}
