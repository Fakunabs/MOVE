//
//  Users.swift
//  MOVE
//
//  Created by Vinh Nguyen on 27/04/2023.
//

import Foundation
import UIKit

enum Gender: Int {
    case male = 1
    case female = 2
    case other = 3
}

// MARK: - Wellcome
struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let token: String?
    let user: User?
    let statusCode: Int

    private enum CodingKeys: String, CodingKey {
        case success, message, token
        case user = "data"
        case statusCode = "status_code"
    }
}

struct User: Codable {
    let id: Int
    var username: String?
    var fullname: String?
    let email: String
    var gender: Int?
    var imagePath, address, birthday: String?
    let isKol: Int
    let userID: Int?
    var countryID: Int?
    var stateID: Int?
    let isSuspended: Int?
    let suspendedUntil: String?
    

    private enum CodingKeys: String, CodingKey {
        case id, username, email, fullname, gender, birthday, address
        case imagePath = "img"
        case isKol = "kol"
        case userID = "user_id"
        case countryID = "country_id"
        case stateID = "state_id"
        case isSuspended = "is_suspended"
        case suspendedUntil = "suspended_until"
    }
    
    func getGender() -> Gender? {
        return Gender(rawValue: gender ?? 0)
    }
}
