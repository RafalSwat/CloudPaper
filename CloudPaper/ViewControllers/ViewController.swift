//
//  ViewController.swift
//  CloudPaper
//
//  Created by Rafał Swat on 26/04/2021.
//

import UIKit

class ViewController: KeyboardHandlingBaseVC {

    @IBOutlet weak var segmentedPicker   : UISegmentedControl!
    @IBOutlet weak var loginTextField    : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var warningLabel      : UILabel!
    @IBOutlet weak var logRegButton      : UIButton!
    
    var securePassword    = true
    var secureFieldButton = UIButton(type: .custom)
    let fireBaseManager   = FireBaseManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tryAutoLogin()
        setupSecureFiledButton(textField: passwordTextField)

        
    }
    @IBAction func switchSegmentedPicker(_ sender: Any) {
        if segmentedPicker.selectedSegmentIndex == 0 {
            
            logRegButton.setTitle("Login", for: UIControl.State.normal)
            
        } else {
            
            logRegButton.setTitle("Registration", for: UIControl.State.normal)
        }
    }
    @IBAction func logRegButtonPressed(_ sender: Any) {
        
        if let error = validateTextFields() {
            warningLabel.text = error
        } else {
            warningLabel.text = ""
            
            let email    = loginTextField.text!
            let password = passwordTextField.text!
            
            if segmentedPicker.selectedSegmentIndex == 0 {
                self.fireBaseManager.login(email: email, password: password) { (successfullyRegistered, errorDescriptyion) in
                    if successfullyRegistered {
                        self.goHome()
                    } else {
                        self.warningLabel.text = errorDescriptyion
                    }
                }
            } else {
                self.fireBaseManager.createUser(email: email, password: password) { (successfullyRegistered, errorDescriptyion) in
                    if successfullyRegistered {
                        self.goHome()
                    } else {
                        self.warningLabel.text = errorDescriptyion
                    }
                }
            }
        }
    }
    @IBAction func showPassword(_ sender: Any) {
        if securePassword {
            securePassword                      = false
            passwordTextField.isSecureTextEntry = false
            secureFieldButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            securePassword                      = true
            passwordTextField.isSecureTextEntry = true
            secureFieldButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    func tryAutoLogin() {
        self.fireBaseManager.autoLogin { (success) in
            if success { self.goHome() }
        }
    }
    
    func validateTextFields() -> String? {
        if loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please, fill in all fields!"
        }
        let cleanPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !Utilities.checkPassword(password: cleanPassword) {
            return "Please, make sure that password is at least 8 characters long, contains a special charcter and a number."
        }
        return nil
    }
    func goHome() {
        loginTextField.text    = ""
        passwordTextField.text = ""
        performSegue(withIdentifier: "goHome", sender: self)
    }
    func setupSecureFiledButton(textField: UITextField) {
        secureFieldButton.setImage(UIImage(systemName: "eye"), for: .normal)
        secureFieldButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        secureFieldButton.addTarget(self, action: #selector(self.showPassword), for: .touchUpInside)
        textField.rightView = secureFieldButton
        textField.rightViewMode = .always
    }
    
}

