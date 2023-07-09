//
//  UpdateInformation.swift
//  MOVE
//
//  Created by Fakunabs on 12/06/2023.
//

import Foundation

// MARK: - UpdateResponse
struct UpdateResponse: Codable {
    let success: Bool
    let message: String
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case success, message
        case statusCode = "status_code"
    }
}
