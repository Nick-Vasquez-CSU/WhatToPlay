//
//  SignUpViewController.swift
//  WhatToPlay
//
//  Created by Ai Chan Tran on 11/8/22.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var emailSignUpTextInput: UITextField!
    var userSignUpTextInput: UITextField!
    var passwordSignUpTextInput: UITextField!
    var logoImage: UIImage!
    var logoImageView: UIImageView!
    var gameTitleLabel: UILabel!
    var registerButton: UIButton!
    
    // pop up message
    var dialogMessage = UIAlertController(title: NSLocalizedString("Success!", comment: "Success"), message: NSLocalizedString("You have successfully created an account!", comment: "Success Create Account"), preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         print(NSLocalizedString("Ok button tapped", comment: "Ok button tapped"))
      })
    
    
    let emailPattern = try! NSRegularExpression(
        pattern: #"[^a-zA-Z0-9_\\-\\.@]"#,
        options: []
    )
    
    var landscape: [NSLayoutConstraint]?
    var portrait: [NSLayoutConstraint]?
    var isPortrait: Bool = false
    var isLandscape: Bool = false
    // Sign up object
    var auth: SignupStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSLocalizedString("SignUpViewController loaded its view.", comment: "SignUpViewController Loaded"))
        emailSignUpTextInput.delegate = self
        emailSignUpTextInput.keyboardType = .emailAddress
        userSignUpTextInput.delegate = self
        passwordSignUpTextInput.delegate = self
        passwordSignUpTextInput.isSecureTextEntry = true
        
        constraints()
        
        self.auth = SignupStore()
    }
    
    override func loadView(){
        super.loadView()
        // adding ok button for popup
        self.dialogMessage.addAction(ok)
        // creating logo image
        self.logoImage = UIImage(named: "joystick.png")
        self.logoImageView = UIImageView()
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.logoImageView.image = self.logoImage
        
        self.view.addSubview(self.logoImageView)
                
        // creating game title label
        self.gameTitleLabel = UILabel()
        self.gameTitleLabel.text = NSLocalizedString("WTP?!", comment: "WTP")
        self.gameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.gameTitleLabel.textAlignment = .center
        self.gameTitleLabel.textColor = .black
        self.gameTitleLabel.font = UIFont.boldSystemFont(ofSize: 46.0)
        
        self.view.addSubview(self.gameTitleLabel)
        
        // creating email text input
        self.emailSignUpTextInput = UITextField()
        self.emailSignUpTextInput.translatesAutoresizingMaskIntoConstraints = false
        self.emailSignUpTextInput.placeholder = NSLocalizedString("Email", comment: "Email")
        self.emailSignUpTextInput.borderStyle = .roundedRect
        self.emailSignUpTextInput.autocorrectionType = .no
        self.emailSignUpTextInput.autocapitalizationType = .none
        self.emailSignUpTextInput.addTarget(self, action: #selector(emailTyped), for: UIControl.Event.editingChanged)
        
        self.view.addSubview(self.emailSignUpTextInput)
        
        // creating username text input
        self.userSignUpTextInput = UITextField()
        self.userSignUpTextInput.translatesAutoresizingMaskIntoConstraints = false
        self.userSignUpTextInput.placeholder = NSLocalizedString("Username", comment: "Username")
        self.userSignUpTextInput.borderStyle = .roundedRect
        self.userSignUpTextInput.autocorrectionType = .no
        self.userSignUpTextInput.autocapitalizationType = .none
        self.userSignUpTextInput.addTarget(self, action: #selector(usernameTyped), for: UIControl.Event.editingChanged)
        
        self.view.addSubview(self.userSignUpTextInput)
        
        // creating password text input
        self.passwordSignUpTextInput = UITextField()
        self.passwordSignUpTextInput.translatesAutoresizingMaskIntoConstraints = false
        self.passwordSignUpTextInput.placeholder = NSLocalizedString("Password", comment: "Password")
        self.passwordSignUpTextInput.borderStyle = .roundedRect
        self.passwordSignUpTextInput.addTarget(self, action: #selector(passwordTyped), for: UIControl.Event.editingChanged)
        
        self.view.addSubview(self.passwordSignUpTextInput)
        
        // creating register button
        self.registerButton = UIButton(type: .system)
        self.registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.registerButton.setTitle(NSLocalizedString("Complete Registration", comment: "Complete Register"), for: UIControl.State.normal)
        self.registerButton.backgroundColor = .green
        self.registerButton.layer.cornerRadius = 5
        self.registerButton.addTarget(self, action: #selector(registerButtonClicked(_:)), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(self.registerButton)
    }
    
    func constraints() {
        
        portrait = [
            // logo image constraint
            self.logoImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 135),
            self.logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            self.logoImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -135),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 270),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 270),
            // game title constraint
            self.gameTitleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 75),
            self.gameTitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 360),
            self.gameTitleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -75),
            // email constraint
            self.emailSignUpTextInput.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 135),
            self.emailSignUpTextInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 450),
            self.logoImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -135),
            self.emailSignUpTextInput.widthAnchor.constraint(equalToConstant: 270),
            self.emailSignUpTextInput.heightAnchor.constraint(equalToConstant: 40),
            // username constraint
            self.userSignUpTextInput.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 135),
            self.userSignUpTextInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 500),
            self.userSignUpTextInput.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -135),
            self.userSignUpTextInput.widthAnchor.constraint(equalToConstant: 270),
            self.userSignUpTextInput.heightAnchor.constraint(equalToConstant: 40),
            // password constraint
            self.passwordSignUpTextInput.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 135),
            self.passwordSignUpTextInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 550),
            self.passwordSignUpTextInput.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -135),
            self.passwordSignUpTextInput.widthAnchor.constraint(equalToConstant: 270),
            self.passwordSignUpTextInput.heightAnchor.constraint(equalToConstant: 40),
            // register button constraint
            self.registerButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 135),
            self.registerButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 600),
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
            // email constraint
            self.emailSignUpTextInput.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            self.emailSignUpTextInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            self.emailSignUpTextInput.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -350),
            self.emailSignUpTextInput.widthAnchor.constraint(equalToConstant: 260),
            self.emailSignUpTextInput.heightAnchor.constraint(equalToConstant: 40),
            // username constraint
            self.userSignUpTextInput.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            self.userSignUpTextInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 90),
            self.userSignUpTextInput.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -350),
            self.userSignUpTextInput.widthAnchor.constraint(equalToConstant: 260),
            self.userSignUpTextInput.heightAnchor.constraint(equalToConstant: 40),
            // password constraint
            self.passwordSignUpTextInput.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            self.passwordSignUpTextInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 150),
            self.passwordSignUpTextInput.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -350),
            self.passwordSignUpTextInput.widthAnchor.constraint(equalToConstant: 260),
            self.passwordSignUpTextInput.heightAnchor.constraint(equalToConstant: 40),
            // register button constraint
            self.registerButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            self.registerButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 210),
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn Range: NSRange, replacementString string: String) -> Bool {
        var acceptChanges = true
        if textField == emailSignUpTextInput {
            let m = self.emailPattern.matches(in: string, range: NSRange(0..<string.count))
            if (!m.isEmpty) {
                print(NSLocalizedString("Invalid symbol.", comment: "Invalid symbol"))
                acceptChanges = false
            }
        }
 
        return acceptChanges
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == passwordSignUpTextInput {
            print(NSLocalizedString("End editing.", comment: "End editing"))
        }
        return true
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.emailSignUpTextInput.resignFirstResponder()
        self.userSignUpTextInput.resignFirstResponder()
        self.passwordSignUpTextInput.resignFirstResponder()
        print(NSLocalizedString("Keyboard dismissed.", comment: "Keyboard dismissed"))
    }
    
    @objc func emailTyped(_sender: UITextField) {
        print(NSLocalizedString("Email typed: ", comment: "Email typed"), self.emailSignUpTextInput.text!)
        if self.emailSignUpTextInput.text!.isEmpty {
            self.emailSignUpTextInput.layer.borderColor = UIColor.red.cgColor
            self.emailSignUpTextInput.layer.borderWidth = 1.0
            //print("field currently empty")
        }
        else {
            self.emailSignUpTextInput.layer.borderWidth = 0
            //print("field not empty")
        }
    }
    
    @objc func usernameTyped(_sender: UITextField) {
        print(NSLocalizedString("Username typed: ", comment: "Username typed"), self.userSignUpTextInput.text!)
        if self.userSignUpTextInput.text!.isEmpty {
            self.userSignUpTextInput.layer.borderColor = UIColor.red.cgColor
            self.userSignUpTextInput.layer.borderWidth = 1.0
            //print("field currently empty")
        }
        else {
            self.userSignUpTextInput.layer.borderWidth = 0
            //print("field not empty")
        }
    }
    
    @objc func passwordTyped(_sender: UITextField) {
        print(NSLocalizedString("Password typed: ", comment: "Password typed"), self.passwordSignUpTextInput.text!)
        if let passWord = passwordSignUpTextInput.text {
            // calling the function
            validatePassword(passWord)
        }
        if self.passwordSignUpTextInput.text!.isEmpty {
            self.passwordSignUpTextInput.layer.borderColor = UIColor.red.cgColor
            self.passwordSignUpTextInput.layer.borderWidth = 1.0
            //print("field currently empty")
        }
        else {
            self.passwordSignUpTextInput.layer.borderWidth = 0
            //print("field not empty")
        }
        
    }
    
    func validatePassword(_ value: String) -> String? {
        if value.count < 6 {
            print(NSLocalizedString("Password must be at least 6 characters.", comment: "Password requirements"))
        }
        if containsDigit(value) {
            print(NSLocalizedString("Password must contain at least 1 digit.", comment: "Password digit"))
        }
        if containsUppercase(value) {
            print(NSLocalizedString("Password must contain at least 1 uppercase character.", comment: "Password uppercase"))
        }
        return nil
    }
    
    func containsDigit(_ value: String) -> Bool {
        let passwordDigitPattern = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordDigitPattern)
        return !predicate.evaluate(with: value)
    }
    func containsUppercase(_ value: String) -> Bool {
        let passwordUppercasePattern = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordUppercasePattern)
        return !predicate.evaluate(with: value)
    }
    
    @objc func registerButtonClicked(_ sender: UIButton) {
        print(NSLocalizedString("Complete registration button clicked", comment: "Complete register"))
        
        if (
            self.emailSignUpTextInput.text != nil
            && self.userSignUpTextInput.text != nil
            && self.passwordSignUpTextInput.text != nil
        ) {
            // RESTful POST request to add user to database
            self.auth.signup(parameters: [
                NSLocalizedString("email", comment: "email"): self.emailSignUpTextInput.text!,
                NSLocalizedString("username", comment: "username"): self.userSignUpTextInput.text!,
                NSLocalizedString("password", comment: "password"): self.passwordSignUpTextInput.text!
            ]) { [self]
                (AuthResult) in
                
                switch AuthResult {
                case let .success(authInfo):
                    if (authInfo.success) {
                        // pop up message
                        self.present(dialogMessage, animated: true, completion: nil)
                        // Signed up successfully
                        print(NSLocalizedString("Signed up successfully!", comment: "Signed up sucessfully"))
                    } else {
                        print(NSLocalizedString("Authentication failed: \(authInfo.msg)", comment: "Authentication failed"))
                    }
                case let .failure(error):
                    print(NSLocalizedString("ERROR: \(error)", comment: "error"))
                }
            }
        } else {
            print(NSLocalizedString("ERROR: Please fill in all required fields", comment: "error"))
        }
    }
}
