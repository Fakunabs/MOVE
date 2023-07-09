//
//  Url.swift
//  MOVE
//
//  Created by Vinh Nguyen on 25/05/2023.
//

import Foundation

struct APIURLs {
    
    static let baseUrl = "https://api.move-intern-stg.madlab.tech/api"
    static let featuredVideos = baseUrl + "/videos-carousel"
    static let suggestionVideos = baseUrl + "/videos-you-may-like"
    static let category = baseUrl + "/featured-categories"
    static let login = baseUrl + "/login"
    static let country =  baseUrl + "/countries"
    static let state = baseUrl + "/countries/{id}/states"
    static let userInformation = baseUrl + "/users/information"
    static let updateProfile = baseUrl + "/users/update-profile"
    static let communityGuidelines = baseUrl + "/community-guidelines"
    static let faqs = baseUrl + "/faqs"
    static let comments = baseUrl + "/comments/"
    static let postComment = baseUrl + "/videos/"
    static let postReply = baseUrl + "/comments/"
    static let videoUrl = "https://vimeo.com/"
    static let videoDetail = baseUrl + "/showVideos/"
    static let postLike = baseUrl + "/comments/"
    static let updateInformation = baseUrl + "/users/update-profile"
}
