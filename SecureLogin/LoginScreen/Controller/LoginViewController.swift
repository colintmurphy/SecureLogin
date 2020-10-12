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
    private var loginReason = "Logging in with Touch ID"
    
    private let email = "colin@gmail.com"
    private let password = "password"
    
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
        checkLogin()
    }
    
    // MARK: - Regular Auth
    
    private func checkLogin() {
        
        let currentEmail = emailTextField.text
        let currentPassword = passwordTextField.text
        
        if currentEmail == email && currentPassword == password {
            self.showAlert(title: "Success!", message: "You've been logged in.")
        } else {
            self.showAlert(title: "Sorry", message: "It looks like either your email and/or password was incorrect.")
        }
    }
    
    // MARK: - Biometric Auth
    
    private func authenticateUserUsingBiometrics() {
        
        guard canEvaluatePolicy() else { return }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { success, error in
            
            if success {
                DispatchQueue.main.async {
                    self.showAlert(title: "Success!", message: "You've been logged in.")
                }
            } else {
                self.showAlert(title: "Error", message: "We could not log you in with FaceID.")
            }
        }
    }
    
    private func canEvaluatePolicy() -> Bool {
        // ask for 
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    private func bioMetricTypeCheck() {
        
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            biometricButton.isHidden = true
        case .touchID:
            if #available(iOS 13.0, *) {
                biometricButton.setBackgroundImage(UIImage(systemName: "touchid"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        case .faceID:
            if #available(iOS 13.0, *) {
                biometricButton.setBackgroundImage(UIImage(systemName: "faceid"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        @unknown default:
            biometricButton.isHidden = true
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        loginButton.layer.cornerRadius = loginButton.bounds.height / 2
        bioMetricTypeCheck()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

