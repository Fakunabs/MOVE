//
//  Comments.swift
//  MOVE
//
//  Created by Vinh Nguyen on 28/04/2023.
//

import Foundation

// MARK: - CommentsResponse
struct CommentsResponse: Codable {
    let success: Bool
    let data: [Comment]
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case success, data
        case statusCode = "status_code"
    }
}
//MARK: - Comment
struct Comment: Codable {
    let id: Int
    let content: String
    let parentCommentId: Int?
    let userId: Int?
    let videoId: Int?
    var likeCount, dislikeCount: Int?
    let createdAt: String?
    let updatedAt: String?
    var replies: [Comment]?
    let user: User?
    var isLiked, isDisliked: Bool?
    let times: String?
        
    enum CodingKeys: String, CodingKey {
        case id, content, replies, user, times
        case parentCommentId = "comment_id"
        case userId = "user_id"
        case videoId = "video_id"
        case likeCount = "like_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isLiked = "is_liked"
        case isDisliked = "is_disliked"
    }
    // Local
    var likeStatus: LikeStatus? {
        get {
            guard let isLiked = isLiked,
                  let isDisliked = isDisliked else { return nil }
            if isLiked && !isDisliked {
                return .liked
            }
            if !isLiked && isDisliked {
                return .disliked
            }
            if !isLiked && !isDisliked  {
                return .noneValue
            }
            return nil
        }
        set {
            switch newValue {
            case .none:
                isLiked = false
                isDisliked = false
            case .liked:
                isLiked = true
                isDisliked = false
            case .disliked:
                isLiked = false
                isDisliked = true
            case .noneValue:
                isLiked = false
                isDisliked = false
            }
        }
    }
    
    var isExpanded: Bool? = false
    var isExpandedInputView: Bool? = false
}

