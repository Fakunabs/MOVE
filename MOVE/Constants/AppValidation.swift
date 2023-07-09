//
//  AppValidation.swift
//  MOVE
//
//  Created by Fakunabs on 16/05/2023.
//

import UIKit

struct AppValidation {
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    static func isValidUsername(_ username: String) -> Bool {
        let usernameRegex = "^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z\\d]{4,25}$"
        return NSPredicate(format: "SELF MATCHES %@", usernameRegex).evaluate(with: username)
    }

    static func isValidFullname(_ fullname: String) -> Bool {
        let fullnameRegex = "^[a-zA-Z .]{4,100}$"
        return NSPredicate(format: "SELF MATCHES %@", fullnameRegex).evaluate(with: fullname)
    }
}
