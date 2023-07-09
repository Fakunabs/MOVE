//
//  CommunityGuidelines.swift
//  MOVE
//
//  Created by Vinh Nguyen on 28/04/2023.
//

import Foundation

// MARK: - CommunityGuidelinesResponse
struct CommunityGuidelinesResponse: Codable {
    let success: Bool
    let data: [CommunityGuideline]
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case success, data
        case statusCode = "status_code"
    }
}
// MARK: - CommunityGuideline
struct CommunityGuideline: Codable {
    let id: Int
    let title, content, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
