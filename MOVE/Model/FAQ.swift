//
//  FAQs.swift
//  MOVE
//
//  Created by Vinh Nguyen on 28/04/2023.
//

import Foundation

struct ListFAQsResponse: Codable {
    let success: Bool
    let data: [FAQ]
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case success, data
        case statusCode = "status_code"
    }
}

struct FAQ: Codable {
    let id: Int
    let title: String?
    let content: String?
    let createdAt: String?
    let updatedAt: String?
    var isExpanded: Bool? // local variable to control expand/collapse cell state

    private enum FAQKeys: String, CodingKey {
        case id, title, content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
