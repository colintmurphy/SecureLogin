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
    
    // MARK: - Variables
    
    private let context = LAContext()
    private var loginReason = "Logging in with Touch ID"
    
    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    
    
    
    // MARK: - Auth Functions
    
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

