//
//  Video.swift
//  MOVE
//
//  Created by Vinh Nguyen on 05/06/2023.
//

import Foundation

//MARK: -VideoDetailResponse
struct VideoDetailResponse: Codable {
    let success: Bool
    let data: Video
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case success, data
        case statusCode = "status_code"
    }
}
// MARK: - Video
struct Video: Codable {

    enum LevelType: Int, CaseIterable{
        case beginner = 1
        case intermediate = 2
        case advanced = 3
        
        var title: String {
            switch self {
            case .beginner:
                return "Beginner"
            case .intermediate:
                return "Intermediate"
            case .advanced:
                return "Advanced"
            }
        }
    }
    
    enum DurationType: Int, CaseIterable {
        case lessThanThirtyMins = 1
        case lessThanOneHour = 2
        case moreThanOneHour = 3
        
        var title: String {
            switch self {
            case .lessThanThirtyMins:
                return "< 30 mins "
            case .lessThanOneHour:
                return "< 1 hour"
            case .moreThanOneHour:
                return "> 1 hour"
            }
        }
    }
    
    let id: Int
    let thumbnailPath: String?
    let totalView: Int?
    let countView: Int?
    let createdAt: String?
    let username: String?
    let avatarPath: String?
    let categoryName: String
    let rating: String?
    let postedDayAgo: Int?
    let title: String?
    let level, duration: Int
    let videoId: String?
    let commentable: Int?
    let userId: Int?
    let rated: Int?
    //local
    var levelTitle: String {
        return LevelType(rawValue: level)?.title ?? ""
    }
    var durationTitle: String {
        return DurationType(rawValue: duration)?.title ?? ""
    }
    var postedTimeString: String {
        guard let postedDayAgo = postedDayAgo else {
            return ""
        }
        return postedDayAgo == 1 ? "A day ago" : "\(postedDayAgo) days ago"
    }
    var roundingRating: String {
        return String(Double(round(10 * (self.rating?.toDouble() ?? 0)) / 10))
    }
    var isJustMove: Bool {
        return categoryName == "Just Move"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case thumbnailPath = "thumbnail"
        case totalView = "total_view"
        case countView = "count_view"
        case createdAt = "created_at"
        case username
        case avatarPath = "img"
        case categoryName = "category_name"
        case rating
        case postedDayAgo = "posted_day_ago"
        case title, level, duration, commentable, rated
        case videoId = "url_video"
        case userId = "user_id"
    }
}

