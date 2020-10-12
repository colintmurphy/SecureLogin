//
//  UIViewController+Ext.swift
//  SecureLogin
//
//  Created by Colin Murphy on 10/12/20.
//

import UIKit

extension UIViewController {

    func showAlert(title: String, message: String) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
