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

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var regMailTextField: UITextField!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    @IBOutlet weak var regPassTextField: UITextField!
    @IBOutlet weak var regConfirmPassTextField: UITextField!
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    // MARK: - Properties
    let realm = try! Realm()
    let alert = AlertView()
    let predicate = EmailValidationPredicate()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        regMailTextField.delegate = self
        regPassTextField.delegate = self
        regConfirmPassTextField.delegate = self
        dismissKeyboardOnTap()
        SetUpOutlets()
        
        
        let results = realm.objects(Users.self)
        print(results)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotifications()
    }
    
    
    func writeToDB() {
        let myUsers = Users()
        let results = realm.objects(Users.self)
        
        let userName = userNameTextField.text
        let userEmail = regMailTextField.text
        let userPass = regPassTextField.text
        let userPassConfirm = regConfirmPassTextField.text
        
        let emailFormatBool = predicate.evaluate(with: userEmail)
        
        
        if (userName!.isEmpty) {
            alert.showAlert(view: self, title: "Incorrect input", message: "Enter UserName!")
            
            return
        } else {
            // Email validation.
            if (userName!.count < 3) {
                alert.showAlert(view: self, title: "Incorrect input", message: "UserName shoud be more than 3 characters!")
                
                return
            }
        }
        
        // Unique user check.
        for i in 0..<results.count {
            if (results[i].userName == userName){
                alert.showAlert(view: self, title: "Incorrect input", message: "User with current UserName already exists!")
                
                return
            } else {
                print("UserName IS UNIQUE")
            }
        }
        
        
        // Email isEmpty check.
        if (userEmail!.isEmpty) {
            alert.showAlert(view: self, title: "Incorrect input", message: "Enter Email!")
            
            return
        } else {
            // Email validation.
            if (!emailFormatBool) {
                alert.showAlert(view: self, title: "Incorrect input", message: "Email format not correct!")
                
                return
            }
        }
        
        // Unique user check.
        for i in 0..<results.count {
            if (results[i].email == regMailTextField.text){
                alert.showAlert(view: self, title: "Incorrect input", message: "User alread ywith current Email exists!")
                
                return
            } else {
                print("EMAIL IS UNIQUE")
            }
        }
        
        // Password isEmpty check.
        if (userPass!.isEmpty || userPassConfirm!.isEmpty) {
            alert.showAlert(view: self, title: "Incorrect input", message: "Enter Password")
            
            return
        } else {
            // Password length check.
            if (userPass!.count < 6) {
                alert.showAlert(view: self, title: "Incorrect input", message: "Password shoud be more than 5 characters!")
                
                return
            }
        }
        
        // Passwords match check.
        if (userPass != userPassConfirm) {
            alert.showAlert(view: self, title: "Incorrect input", message: "Passwords are not the same!")
            
            return
        } else {
            saveLoggedState()
            performSegue(withIdentifier: "signup_to_menu", sender: self)
        }
        
        writeDefaultScore()
        myUsers.userName = userName
        myUsers.email = userEmail
        myUsers.password = userPass
        
        try! realm.write {
            realm.add(myUsers)
        }
    }
    
    // Save authorize state.
    func saveLoggedState() {
        let def = UserDefaults.standard
        def.set(true, forKey: "isLoggedIn")
        def.set(userNameTextField.text, forKey: "currentUser")
        def.synchronize()
    }
    
    func writeDefaultScore() {
        let topScores = TopScores()
        
        let def = UserDefaults.standard
        let currentUser = def.string(forKey: "currentUser")
        
        //        let currentUserResult = realm.objects(TopScores.self)
        
        topScores.userName = currentUser
        topScores.score = "0"
        
        try! realm.write {
            realm.add(topScores)
        }
    }
    
    // MARK: - Actions
    @IBAction func registerButtonAction(_ sender: Any) {
        dismissKeyboard()
        writeToDB()
        // signup_to_menu
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
    }
    
    // SetUpOutlets
    private func SetUpOutlets() {
        userNameTextField.layer.cornerRadius = 5
        userNameTextField.layer.borderWidth = 0.5
        userNameTextField.layer.borderColor = UIColor.gray.cgColor
        userNameTextField.textContentType = UITextContentType(rawValue: "")
        
        regMailTextField.layer.cornerRadius = 5
        regMailTextField.layer.borderWidth = 0.5
        regMailTextField.layer.borderColor = UIColor.gray.cgColor
        regMailTextField.textContentType = UITextContentType(rawValue: "")
        
        regPassTextField.layer.cornerRadius = 5
        regPassTextField.layer.borderWidth = 0.5
        regPassTextField.layer.borderColor = UIColor.gray.cgColor
        regPassTextField.textContentType = UITextContentType(rawValue: "")
        
        regConfirmPassTextField.layer.cornerRadius = 5
        regConfirmPassTextField.layer.borderWidth = 0.5
        regConfirmPassTextField.layer.borderColor = UIColor.gray.cgColor
        regConfirmPassTextField.textContentType = UITextContentType(rawValue: "")
        
        registerButtonOutlet.layer.cornerRadius = 5
        registerButtonOutlet.layer.borderWidth = 0.5
        registerButtonOutlet.layer.borderColor = UIColor.gray.cgColor
        
        backButtonOutlet.layer.cornerRadius = 5
        backButtonOutlet.layer.borderWidth = 0.5
        backButtonOutlet.layer.borderColor = UIColor.gray.cgColor
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
    
    // Notifications for moving view when keyboard appears.
    func setUpNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Removing notifications.
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if userNameTextField.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height + 100
            } else if regMailTextField.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height + 100
            } else if regPassTextField.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height + 100
            }  else if regConfirmPassTextField.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height + 100
            }
        }
    }
    
    //    // Hide the keyboard when the return key pressed.
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //        return true
    //    }
    
}
