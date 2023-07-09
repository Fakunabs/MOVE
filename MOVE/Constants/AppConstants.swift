//
//  AppConstants.swift
//  MOVE
//
//  Created by Fakunabs on 06/06/2023.
//

import Foundation

struct AppConstants {
    struct UserDefaults {
        static let accessToken = "accessToken"
        static let user = "user"
    }
    struct NotificationName {
        static let loginSuccess = "com.user.login.success"
    }
    
    struct Suspended {
        static let content = "[This comment has been removed due to violation of community guideline]"
        static let username = "Suspended MOVE Account"
    }
}
