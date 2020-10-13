//
//  LoginViewController.swift
//  SecureLogin
//
//  Created by Colin Murphy on 10/10/20.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var biometricButton: UIButton!
    
    // MARK: - Variables
    
    private let context = LAContext()
    private var loginReason = "User Authentication"
    
    private let email = "colin@gmail.com"
    private let password = "password"
    private var biometricType: BiometricType = .none
    
    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - IBActions
    
    @IBAction private func useFaceId(_ sender: Any) {
        authenticateUserUsingBiometrics()
    }
    
    @IBAction private func login(_ sender: Any) {
        
        guard let currentEmail = emailTextField.text,
              let currentPassword = passwordTextField.text else {
            showAlert(title: "Oops!", message: "Please make sure you enter you email and you password.")
            return
        }
        checkIfLoginValid(email: currentEmail, password: currentPassword)
    }
    
    // MARK: - Biometric Auth
    
    private func authenticateUserUsingBiometrics() {
        
        guard canEvaluatePolicy() else {
            showAlert(title: "Oops!", message: "It looks like you need to enable \(biometricType.rawValue).")
            return
        }
        
        guard let email = emailTextField.text,
              !email.isEmpty else {
            showAlert(title: "Oops!", message: "Please make sure you enter you email.")
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { success, error in
            if success {
                DispatchQueue.main.async {
                    
                    if let password = KeychainWrapper.standard.string(forKey: email) {
                        self.checkIfLoginValid(email: email, password: password)
                    } else {
                        self.showAlert(title: "Sorry", message: "Please ensure your email is correct. If you are logging in for the first time, please login with your password before using \(self.biometricType.rawValue).")
                    }
                }
            }
        }
    }
    
    // MARK: - Biometric Setup Helpers
    
    private func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    private func bioMetricTypeCheck() {
        
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            biometricType = BiometricType.none
            biometricButton.isHidden = true
        case .touchID:
            biometricType = .touchId
            biometricButton.setBackgroundImage(UIImage(systemName: "touchid"), for: .normal)
        case .faceID:
            biometricType = .faceId
            biometricButton.setBackgroundImage(UIImage(systemName: "faceid"), for: .normal)
        @unknown default:
            biometricType = BiometricType.none
            biometricButton.isHidden = true
        }
    }
    
    // MARK: - Check Credentials
    
    private func checkIfLoginValid(email: String, password: String) {
        
        if self.email == email && self.password == password {
            showAlert(title: "Success!", message: "You've been logged in.")
            KeychainWrapper.standard.set(password, forKey: email)
        } else {
            showAlert(title: "Sorry", message: "It looks like either your email and/or password was incorrect.")
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        loginButton.layer.cornerRadius = loginButton.bounds.height / 2
        bioMetricTypeCheck()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        showAlert(title: "Welcome!", message: "The email and password to test this demo app is colin@gmail.com and password.")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

