//
//  UIViewController+Extension.swift
//  Flicker
//
//  Created by Amr fawzy on 6/22/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import UIKit


extension UIViewController {
    
    /// alert message

    func showAlert(title: String, message: String, cancel: String = "Cancel") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert(title: String = "Error", message: String, cancel: String = "Cancel") {
        showAlert(title: title, message: message, cancel: cancel)
    }
    
}
