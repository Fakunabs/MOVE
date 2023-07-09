//
//  Category.swift
//  MOVE
//
//  Created by Vinh Nguyen on 28/04/2023.
//

import Foundation

// MARK: - ListCategoriesResponse
struct ListCategoriesResponse: Codable {
    let success: Bool
    let data: [Category]
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case success, data
        case statusCode = "status_code"
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String
    let image: String
    let viewCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case image = "img"
        case viewCount = "view_count"
    }
}
