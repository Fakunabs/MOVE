//
//  VideoSuggestion.swift
//  MOVE
//
//  Created by Vinh Nguyen on 29/05/2023.
//

import Foundation

// MARK: - SuggestionVideosResponse
struct SuggestionVideosResponse: Codable {
    let success: Bool
    let result: ListSuggestionVideos
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case success
        case result = "data"
        case statusCode = "status_code"
    }
}
// MARK: - ListSuggestionVideos
struct ListSuggestionVideos: Codable {
    let currentPage: Int
    let data: [Video]
    let firstPageURLPath: String?
    let from: Int?
    let nextPageURLPath, path: String?
    let perPage: Int?
    let prevPageURLPath: String?
    let to: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURLPath = "first_page_url"
        case from
        case nextPageURLPath = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURLPath = "prev_page_url"
        case to
    }
}
