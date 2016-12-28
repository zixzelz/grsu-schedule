//
//  AuthenticationViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/22/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userLoginTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonPressed() {

        guard let login = userLoginTextField.text where !login.isEmpty else {
            showMessage("Поле «Логин» должно быть заполнено")
            return
        }

        AuthenticationService().auth(login) { [weak self] (result)  in
            guard let strongSelf = self else {return}
            
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
}
