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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonPressed() {
        
    }
    
    @IBAction func cancelButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
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
