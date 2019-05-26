//
//  SignInViewController.swift
//  SwGame
//
//  Created by Тимур Кошевой on 1/4/19.
//  Copyright © 2019 Тимур Кошевой. All rights reserved.
//

import UIKit
import RealmSwift
import ValidationComponents

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var userNameTextFieldOutlet: UITextField!
    @IBOutlet weak var passwordTextFieldOutlet: UITextField!
    @IBOutlet weak var logInButtonOutlet: UIButton!
    @IBOutlet weak var goToSignUpButtonOutlet: UIButton!
    
    // MARK: - Properties
    let realm = try! Realm()
    let alert = AlertView()
    
    // MARK: - Functions
    override func loadView() {
        super.loadView()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        userNameTextFieldOutlet.delegate = self
        passwordTextFieldOutlet.delegate = self
        SetUpOutlets()
        dismissKeyboardOnTap()
        
        let def = UserDefaults.standard
        let currentUser = def.string(forKey: "currentUser")
        print(currentUser)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotifications()
    }
    
    // Validate user.
    func validateUser() {
        
        let userName = userNameTextFieldOutlet.text
        let userPass = passwordTextFieldOutlet.text
        var userNameMatch = false
        var passMatch = false
        
        // Email isEmpty check.
        if (userName!.isEmpty) {
            alert.showAlert(view: self, title: "Incorrect input", message: "Enter UserName!")
            
            return
        }
        
        // Password isEmpty check.
        if (userPass!.isEmpty) {
            alert.showAlert(view: self, title: "Incorrect input", message: "Enter password!")
            
            return
        } else {
            // Password length check.
            if (userPass!.count < 6) {
                alert.showAlert(view: self, title: "Incorrect input", message: "Password shoud be more than 5 characters!")
                
                return
            }
        }
        
        // get all users from database
        let results = realm.objects(Users.self)
        
        // Username and password match.
        for i in 0..<results.count {
            if (results[i].userName == userName){
                userNameMatch = true
                
                if (results[i].password == userPass) {
                    passMatch = true
                }
            }
        }
        
        if (userNameMatch) {
            if (passMatch) {
                // Email and password correct.
                performSegue(withIdentifier: "login_to_menu", sender: self)
                saveLoggedState()
            } else {
                // Password is wrong.
                alert.showAlert(view: self, title: "Incorrect input", message: "Wrong password!")
                
                return
            }
        } else {
            // Email is wrong.
            alert.showAlert(view: self, title: "Incorrect input", message: "Wrong userName!")
            
            return
        }
    }
    
    // Save authorize state.
    func saveLoggedState() {
        let def = UserDefaults.standard
        def.set(true, forKey: "isLoggedIn")
        def.set(userNameTextFieldOutlet.text, forKey: "currentUser")
        def.synchronize()
    }
    
    // MARK: - Actions
    @IBAction func logInButtonAction(_ sender: Any) {
        dismissKeyboard()
        validateUser()
    }
    
    @IBAction func goToSignUpButtonAction(_ sender: Any) {
        dismissKeyboard()
    }
    
    // SetUpOutlets
    func SetUpOutlets() {
        userNameTextFieldOutlet.layer.cornerRadius = 5
        userNameTextFieldOutlet.layer.borderWidth = 0.5
        userNameTextFieldOutlet.layer.borderColor = UIColor.gray.cgColor
        userNameTextFieldOutlet.textContentType = UITextContentType(rawValue: "")
        
        passwordTextFieldOutlet.layer.cornerRadius = 5
        passwordTextFieldOutlet.layer.borderWidth = 0.5
        passwordTextFieldOutlet.layer.borderColor = UIColor.gray.cgColor
        passwordTextFieldOutlet.isSecureTextEntry = true
        passwordTextFieldOutlet.textContentType = UITextContentType(rawValue: "")
        
        
        logInButtonOutlet.layer.cornerRadius = 5
        logInButtonOutlet.layer.borderWidth = 0.5
        logInButtonOutlet.layer.borderColor = UIColor.gray.cgColor
        
        goToSignUpButtonOutlet.layer.cornerRadius = 5
        goToSignUpButtonOutlet.layer.borderWidth = 0.5
        goToSignUpButtonOutlet.layer.borderColor = UIColor.gray.cgColor
    }
    
    // Notifications for moving view when keyboard appears.
    func setUpNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Removing notifications.
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Move view back when keyboard hide.
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if passwordTextFieldOutlet.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height + 100
            } else if userNameTextFieldOutlet.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height + 100
            }
        }
    }
    
    // Hide keyboard on tap.
    func dismissKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Hide Keyboard.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Hide the keyboard when the return key pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
