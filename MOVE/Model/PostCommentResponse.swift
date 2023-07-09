//
//  PostCommentResponse.swift
//  MOVE
//
//  Created by Vinh Nguyen on 13/06/2023.
//

import Foundation

// MARK: - PostCommentResponse
struct PostCommentResponse: Codable {
    let success: String
    let result: Comment
    let statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case success
        case result = "data"
        case statusCode = "status_code"
    }
}
