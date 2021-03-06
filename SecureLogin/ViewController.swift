//
//  LoginViewController.swift
//  SecureLogin
//
//  Created by Colin Murphy on 10/10/20.
//

import UIKit
import LocalAuthentication

enum BiometricType {
    
    case none
    case touchId
    case faceId
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.layer.cornerRadius = emailTextField.bounds.height / 2
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.layer.cornerRadius = passwordTextField.bounds.height / 2
        }
    }
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = loginButton.bounds.height / 2
        }
    }
    
    private let context = LAContext()
    private var loginReason = "Logging in with Touch ID"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func authenticateUser() {
        
        guard canEvaluatePolicy() else { return }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { success, error in
            
            if success {
                DispatchQueue.main.async {
                    
                }
            } else {
                
            }
        }
    }
    
    private func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    private func bioMetricType() -> BiometricType {
        
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchId
        case .faceID:
            return .faceId
        @unknown default:
            return .none
        }
    }
}

