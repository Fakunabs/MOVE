//
//  UIViewController+Extension.swift
//  MOVE
//
//  Created by Fakunabs on 15/06/2023.
//

import Foundation
import UIKit

enum AlertViewActionType {
    case ok
    case cancel
    case destructive
    
}
extension UIViewController {
    
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   successButtonTitle: String? = nil,
                   cancelButtonTitle: String? = nil,
                   destructiveButtonTitle: String? = nil,
                   handler: ((AlertViewActionType) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if successButtonTitle != nil {
            alertController.addAction(UIAlertAction(title: successButtonTitle, style: .default, handler: { _ in
                handler?(.ok)
            }))
        }
        if cancelButtonTitle != nil {
            alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .default, handler: { _ in
                handler?(.cancel)
            }))
        }
        if destructiveButtonTitle != nil {
            alertController.addAction(UIAlertAction(title: destructiveButtonTitle, style: .default, handler: { _ in
                handler?(.destructive)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
