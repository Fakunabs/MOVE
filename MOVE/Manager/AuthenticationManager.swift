//
//  AuthenticationManager.swift
//  MOVE
//
//  Created by Fakunabs on 06/06/2023.
//

import Foundation

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    var user: User?
    var accessToken: String?
    
    init() {
        self.user = getUser()
        self.accessToken = getAccessToken()
    }
    
    var isLoggedIn: Bool {
        return  accessToken != nil && user != nil
    }
}

extension AuthenticationManager {
    func cleanCache() {
        cache(user: nil)
        cache(accessToken: nil)
    }
}

extension AuthenticationManager {
    func cache(accessToken: String?) {
        self.accessToken = accessToken
        UserDefaults.standard.set(accessToken, forKey: AppConstants.UserDefaults.accessToken)
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: AppConstants.UserDefaults.accessToken)
    }
}

extension AuthenticationManager {
    
    func cache(user: User?) {
        self.user = user
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: AppConstants.UserDefaults.user)
        } catch {
            print("Unable to Encode User (\(error.localizedDescription))")
        }
    }
    
    func getUser() -> User? {
        
        if let data = UserDefaults.standard.data(forKey: AppConstants.UserDefaults.user) {
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                return user
            } catch {
                print("Unable to Decode User (\(error.localizedDescription))")
            }
        }
        return nil
    }
}
