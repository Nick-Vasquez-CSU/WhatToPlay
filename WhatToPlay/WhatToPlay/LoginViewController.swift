//
//  ViewController.swift
//  WhatToPlay
//
//  Created by Ai Chan Tran on 11/7/22.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // creating elements
    var userLogInTextInput: UITextField!
    var passwordLogInTextInput: UITextField!
    var logoImage: UIImage!
    var logoImageView: UIImageView!
    var gameTitleLabel: UILabel!
    var signInButton: UIButton!
    var registerButton: UIButton!
    
    // defaults for saved username
    var rememberMe: UISwitch!
    var isChecked = false
    let userDefaults = UserDefaults()
    
    // for changing orientation
    var landscape: [NSLayoutConstraint]?
    var portrait: [NSLayoutConstraint]?
    var isPortrait: Bool = false
    var isLandscape: Bool = false
    
    // Object for authentication
    var auth: LoginStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userLogInTextInput.delegate = self
        passwordLogInTextInput.delegate = self
        passwordLogInTextInput.isSecureTextEntry = true
        
        checkifUserisSaved()
        
        
        self.auth = LoginStore()
        
        
        constraints()
        
        
    }
    
    
    
    override func loadView(){
        super.loadView()
        // creating logo image
        self.logoImage = UIImage(named: "joystick.png")
        self.logoImageView = UIImageView()
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.logoImageView.image = self.logoImage
        
        self.view.addSubview(self.logoImageView)
        
        // creating game title label
        self.gameTitleLabel = UILabel()
        self.gameTitleLabel.text = NSLocalizedString("WTP?!", comment: "Game Title")
        self.gameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.gameTitleLabel.textAlignment = .center
        self.gameTitleLabel.textColor = .black
        self.gameTitleLabel.font = UIFont.boldSystemFont(ofSize: 46.0)
        
        self.view.addSubview(self.gameTitleLabel)
        
        // creating username text input
        self.userLogInTextInput = UITextField()
        self.userLogInTextInput.translatesAutoresizingMaskIntoConstraints = false
        self.userLogInTextInput.placeholder = NSLocalizedString("Username", comment: "Username")
        self.userLogInTextInput.borderStyle = .roundedRect
        self.userLogInTextInput.autocorrectionType = .no
        self.userLogInTextInput.autocapitalizationType = .none
        self.userLogInTextInput.addTarget(self, action: #selector(usernameTyped), for: UIControl.Event.editingChanged)
        
        self.view.addSubview(self.userLogInTextInput)
        
        // creating password text input
        self.passwordLogInTextInput = UITextField()
        self.passwordLogInTextInput.translatesAutoresizingMaskIntoConstraints = false
        self.passwordLogInTextInput.placeholder = NSLocalizedString("Password", comment: "Password")
        self.passwordLogInTextInput.borderStyle = .roundedRect
        self.passwordLogInTextInput.addTarget(self, action: #selector(passwordTyped), for: UIControl.Event.editingChanged)
        
        self.view.addSubview(self.passwordLogInTextInput)
        
        // creating sign in button
        self.signInButton = UIButton(type: .system)
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.signInButton.setTitle(NSLocalizedString("Sign In", comment: "Sign In Button"), for: UIControl.State.normal)
        self.signInButton.backgroundColor = .green
        self.signInButton.layer.cornerRadius = 5
        self.signInButton.addTarget(self, action: #selector(signInButtonClicked(_:)), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(self.signInButton)
        
        // creating remember me slider
        self.rememberMe = UISwitch()
        self.rememberMe.onTintColor = .red
        //self.rememberMe.title = "Remember Username?"
        self.rememberMe.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.rememberMe)
        
        // creating sign in button
        self.registerButton = UIButton(type: .system)
        self.registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.registerButton.setTitle(NSLocalizedString("Don't have an account? Register!", comment: "Register Button"), for: UIControl.State.normal)
        self.registerButton.backgroundColor = .yellow
        self.registerButton.layer.cornerRadius = 5
        self.registerButton.addTarget(self, action: #selector(registerButtonClicked(_:)), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(self.registerButton)
    }
    
    func constraints() {
        
        portrait = [
            // logo image constraint
            
            //ipad
            //self.logoImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 200),
            //self.logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            //self.logoImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -200),
            
            //iphone
            self.logoImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 135),
            self.logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            self.logoImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -135),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 270),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 270),
            // game title constraint
            self.gameTitleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 75),
            self.gameTitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 360),
            self.gameTitleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -75),
            // username log in constraint
            self.userLogInTextInput.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 135),
            self.userLogInTextInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 450),
            self.userLogInTextInput.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -135),
            self.userLogInTextInput.widthAnchor.constraint(equalToConstant: 270),
            self.userLogInTextInput.heightAnchor.constraint(equalToConstant: 40),
            // password constraint
            self.passwordLogInTextInput.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 135),
            self.passwordLogInTextInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 500),
            self.passwordLogInTextInput.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -135),
            self.passwordLogInTextInput.widthAnchor.constraint(equalToConstant: 270),
            self.passwordLogInTextInput.heightAnchor.constraint(equalToConstant: 40),
            // remember slider constraint
            self.rememberMe.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 135),
            self.rememberMe.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 600),
            self.rememberMe.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -135),
            // sign in button constraint
            self.signInButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 135),
            self.signInButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 550),
            self.signInButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -135),
            self.signInButton.widthAnchor.constraint(equalToConstant: 270),
            self.signInButton.heightAnchor.constraint(equalToConstant: 40),
            // reg button constraint
            self.registerButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 135),
            self.registerButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 650),
            self.registerButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -135),
            self.registerButton.widthAnchor.constraint(equalToConstant: 270),
            self.registerButton.heightAnchor.constraint(equalToConstant: 40)
            
            
        ]
        landscape = [
            // logo image constraint
            self.logoImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            self.logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 70),
            self.logoImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 100),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 200),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 200),
            // game title constraint
            self.gameTitleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 520),
            self.gameTitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.gameTitleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -100),
            // username log in constraint
            self.userLogInTextInput.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            self.userLogInTextInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            self.userLogInTextInput.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -350),
            self.userLogInTextInput.widthAnchor.constraint(equalToConstant: 260),
            self.userLogInTextInput.heightAnchor.constraint(equalToConstant: 40),
            // password constraint
            self.passwordLogInTextInput.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            self.passwordLogInTextInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 90),
            self.passwordLogInTextInput.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -350),
            self.passwordLogInTextInput.widthAnchor.constraint(equalToConstant: 260),
            self.passwordLogInTextInput.heightAnchor.constraint(equalToConstant: 40),
            // remember me
            self.rememberMe.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            self.rememberMe.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 195),
            self.rememberMe.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -350),
            // sign in button constraint
            self.signInButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            self.signInButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 150),
            self.signInButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -350),
            self.signInButton.widthAnchor.constraint(equalToConstant: 260),
            self.signInButton.heightAnchor.constraint(equalToConstant: 40),
            // reg button constraint
            self.registerButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            self.registerButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 230),
            self.registerButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -350),
            self.registerButton.widthAnchor.constraint(equalToConstant: 260),
            self.registerButton.heightAnchor.constraint(equalToConstant: 40)
        ]
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //print("device rotated.")
        
        isPortrait = UIDevice.current.orientation.isPortrait
        isLandscape = UIDevice.current.orientation.isLandscape
        if isPortrait {
            NSLayoutConstraint.deactivate(landscape!)
            NSLayoutConstraint.activate(portrait!)
        } else if isLandscape {
            NSLayoutConstraint.deactivate(portrait!)
            NSLayoutConstraint.activate(landscape!)
        } else {
            NSLayoutConstraint.deactivate(landscape!)
            NSLayoutConstraint.activate(portrait!)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == passwordLogInTextInput {
            print(NSLocalizedString("End editing.", comment: "End editing"))
        }
        return true
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.userLogInTextInput.resignFirstResponder()
        self.passwordLogInTextInput.resignFirstResponder()
        print(NSLocalizedString("Keyboard dismissed.", comment: "Keyboard dismissed"))
    }
    
    @objc func usernameTyped(_sender: UITextField) {
        print(NSLocalizedString("Username typed: ", comment: "Username typed:"), self.userLogInTextInput.text!)
        if self.userLogInTextInput.text!.isEmpty {
            self.userLogInTextInput.layer.borderColor = UIColor.red.cgColor
            self.userLogInTextInput.layer.borderWidth = 1.0
            //print("field currently empty")
        }
        else {
            self.userLogInTextInput.layer.borderWidth = 0
            //print("field not empty")
        }
    }
    
    @objc func passwordTyped(_sender: UITextField) {
        print(NSLocalizedString("Username typed: ", comment: "Username typed:"), self.passwordLogInTextInput.text!)
        if self.passwordLogInTextInput.text!.isEmpty {
            self.passwordLogInTextInput.layer.borderColor = UIColor.red.cgColor
            self.passwordLogInTextInput.layer.borderWidth = 1.0
            //print("field currently empty")
        }
        else {
            self.passwordLogInTextInput.layer.borderWidth = 0
            //print("field not empty")
        }
        
    }
    
    @objc func signInButtonClicked(_ sender: UIButton) {
        print(NSLocalizedString("Sign in button clicked", comment: "Sign in"))
        
        if (userLogInTextInput.text != nil && passwordLogInTextInput.text != nil) {
            
            // RESTful POST request
            self.auth.login(parameters: [
                "username": userLogInTextInput.text!,
                "password": passwordLogInTextInput.text!
            ]) {
                (AuthResult) in
                
                switch AuthResult {
                case let .success(authInfo):
                    if (authInfo.success) {

                        print(NSLocalizedString("Successfully logged in!", comment: "Logged in Success"))
                        if (self.rememberMe.isOn) {
                            print("Remembering Username!")
                            self.saveUsername()
                        }
                        else {
                            print("Unremember Username!")
                            self.remUsername()
                        }

                        self.performSegue(withIdentifier: "LogIn", sender: self)
                    } else {
                        print(NSLocalizedString("Authentication failed. \(authInfo.msg)", comment: "Authentication failed"))
                    }
                case let .failure(error):
                    print(NSLocalizedString("Authentication failed. Please try again: \(error)", comment: "Authentication failed."))
                }
            }
        } else {
            print(NSLocalizedString("incorrect username and password, try again", comment: "Incorrect"))
        }
    }
    
    @objc func registerButtonClicked(_ sender: UIButton) {
        print(NSLocalizedString("Register button clicked", comment: "Register button clicked"))
        self.performSegue(withIdentifier: "SignUp", sender: self)
    }
    
    func saveUsername(){
        userDefaults.set(userLogInTextInput.text!, forKey: "user")
    }
    func remUsername(){
        userDefaults.set("", forKey: "user")
    }
    func checkifUserisSaved(){
        let user = userDefaults.value(forKey: "user") as? String ?? ""
        userLogInTextInput.text = user
    }
}

