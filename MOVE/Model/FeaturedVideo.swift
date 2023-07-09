//
//  FeaturedVideo.swift
//  MOVE
//
//  Created by Vinh Nguyen on 28/04/2023.
//

import Foundation

// MARK: - FeaturedVideosResponse
struct FeaturedVideosResponse: Codable {
    let success: Bool
    let data: [Video]
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case success, data
        case statusCode = "status_code"
    }
}
