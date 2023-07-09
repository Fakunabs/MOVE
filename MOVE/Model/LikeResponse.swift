//
//  LikeResponse.swift
//  MOVE
//
//  Created by Vinh Nguyen on 14/06/2023.
//

import Foundation

// MARK: - LikeResponse
struct LikeResponse: Codable {
    let success: String
    let result: Bool
    let statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case success
        case result = "data"
        case statusCode = "status_code"
    }
}
