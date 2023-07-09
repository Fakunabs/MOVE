//
//  Repository.swift
//  MOVE
//
//  Created by Vinh Nguyen on 31/05/2023.
//

import Foundation
import Alamofire

class Repository {
    
    static func getFeaturedVideo() async throws -> [Video]{
        
        do{
            let data: FeaturedVideosResponse = try await APIService.shareInitial.requestAPIData(from: APIURLs.featuredVideos, parameters: nil, method: .get, headers: nil)
            let featuredVideos: [Video] = data.data
            return featuredVideos
        } catch {
            print(String(describing: error))
        }
        return []
    }
    
    static func getSuggestionVideos() async throws -> [Video]{
        
        do{
            let headers: HTTPHeaders?
            if let token = AuthenticationManager.shared.accessToken {
                headers = [
                    "Authorization": "Bearer \(token)"
                ]
            } else {
                headers = nil
            }
            let data: SuggestionVideosResponse = try await APIService.shareInitial.requestAPIData(from: APIURLs.suggestionVideos, parameters: nil, method: .get, headers: headers)
            let suggestionVideos: [Video] = data.result.data
            return suggestionVideos
        } catch {
            print(String(describing: error))
        }
        return []
    }
    
    static func getListCategories() async throws -> [Category]{
        
        do{
            let data: ListCategoriesResponse = try await APIService.shareInitial.requestAPIData(from: APIURLs.category, parameters: nil, method: .get, headers: nil)
            let listCategories: [Category] = data.data
            return listCategories
        } catch {
            print(String(describing: error))
        }
        return []
    }
    
    static func login(email: String, password: String) async throws -> User? {
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        do {
            let data: LoginResponse = try await APIService.shareInitial.requestAPIData(from: APIURLs.login, parameters: parameters, method: .post, headers: nil)
            let user = data.user
            AuthenticationManager.shared.cache(user: user)
            AuthenticationManager.shared.cache(accessToken: data.token)
            return user
        } catch {
            throw error
        }
    }
    
    static func getListCountries() async throws -> [Country]{
        
        do{
            let data: ListCountriesResponse = try await APIService.shareInitial.requestAPIData(from: APIURLs.country, parameters: nil, method: .get, headers: nil)
            let listCountries: [Country] = data.data
            return listCountries
        } catch {
            print(String(describing: error))
        }
        return []
    }
    
    static func getlistStates(id: Int) async throws -> [State]{
        
        do{
            let data: listStatesResponse = try await APIService.shareInitial.requestAPIData(from: APIURLs.state.replacingOccurrences(of: "{id}", with: "\(id)"), parameters: nil, method: .get, headers: nil)
            let listStates: [State] = data.data
            return listStates
        } catch {
            print(String(describing: error))
        }
        return []
    }
    
    static func getListCommunityGuidelines() async throws -> [CommunityGuideline] {
        
        do{
            let data: CommunityGuidelinesResponse = try await APIService.shareInitial.requestAPIData(from: APIURLs.communityGuidelines, parameters: nil, method: .get, headers: nil)
            let communityGuideline: [CommunityGuideline] = data.data
            return communityGuideline
            
        } catch {
            print(String(describing: error))
        }
        return []
    }
    
    static func getListFAQs() async throws -> [FAQ]{
        
        do{
            let data: ListFAQsResponse = try await APIService.shareInitial.requestAPIData(from: APIURLs.faqs, parameters: nil, method: .get, headers: nil)
            let listFAQs: [FAQ] = data.data
            return listFAQs
            
        } catch {
            print(String(describing: error))
        }
        return []
    }
    
    static func getListComments(id: Int) async throws -> [Comment]{
        
        do{
            let urlString = APIURLs.comments + "\(id)"
            let headers: HTTPHeaders?
            if let token = AuthenticationManager.shared.accessToken {
                headers = [
                    "Authorization": "Bearer \(token)"
                ]
            } else {
                headers = nil
            }
            let data: CommentsResponse = try await APIService.shareInitial.requestAPIData(from: urlString, parameters: nil, method: .get, headers: headers)
            let listComments: [Comment] = data.data
            return listComments
        } catch {
            print(String(describing: error))
        }
        return []
    }
    
    static func sendComment(id: Int, content: String) async throws -> Comment?{
        do {
            let urlString = APIURLs.postComment + "\(id)" + "/comments"
            let parameters: [String: Any] = [ "content": content ]
            
            let headers: HTTPHeaders?
            if let token = AuthenticationManager.shared.accessToken {
                headers = [
                    "Authorization": "Bearer \(token)"
                ]
            } else {
                return nil
            }
            
            let data: PostCommentResponse = try await APIService.shareInitial.requestAPIData(from: urlString, parameters: parameters, method: .post, headers: headers)
            let comment: Comment = data.result
            print("====\(data.success)====")
            return comment
        } catch {
            print("====ERROR Send Comment====")
            print(String(describing: error))
        }
        return nil
    }
    
    static func updateInformation(username: String, fullname: String, gender: Int, birthday: String, countryID: Int, stateID: Int, address: String) async throws -> Bool {
        let parameters: [String: Any] = [
            "username": username,
            "fullname": fullname,
            "gender": gender,
            "birthday": birthday,
            "country_id": String(countryID),
            "state_id": String(stateID),
            "address": address
        ]
        do {
            let headers: HTTPHeaders?
            if let token = AuthenticationManager.shared.accessToken {
                headers = [
                    "Authorization": "Bearer \(token)"
                ]
            } else {
                headers = nil
            }
            let data : UpdateResponse = try await APIService.shareInitial.requestAPIData(from: APIURLs.updateInformation, parameters: parameters, method: .put, headers: headers)
            return data.success
        } catch {
            throw error
        }
        return false
    }
    
    static func sendReply(id: Int, content: String) async throws -> Comment?{
        do {
            let urlString = APIURLs.postReply + "\(id)" + "/reply"
            let parameters: [String: Any] = [ "content": content ]
            let headers: HTTPHeaders?
            if let token = AuthenticationManager.shared.accessToken {
                headers = [
                    "Authorization": "Bearer \(token)"
                ]
            } else {
                return nil
            }
            let data: PostCommentResponse = try await APIService.shareInitial.requestAPIData(from: urlString, parameters: parameters, method: .post, headers: headers)
            let comment: Comment = data.result
            print("====\(data.success)====")
            return comment
        } catch {
            print("====ERROR Send Comment====")
            print(String(describing: error))
        }
        return nil
    }
    
    static func getVideoDetail(id: Int) async throws -> Video? {
        
        do{
            let urlString = APIURLs.videoDetail + "\(id)"
            let data: VideoDetailResponse = try await APIService.shareInitial.requestAPIData(from: urlString, parameters: nil, method: .get, headers: nil)
            let video: Video = data.data
            return video
        } catch {
            print(String(describing: error))
        }
        return nil
    }
    
    static func postLike(id: Int, status: LikeStatus) async throws -> Bool {
        do {
            let statusRequest = status == .liked ? "/like" : "/dislike"
            let urlString = APIURLs.postLike + "\(id)" + "\(statusRequest)"
            let headers: HTTPHeaders?
            guard let token = AuthenticationManager.shared.accessToken else {
                return false
            }
            headers = [
                "Authorization": "Bearer \(token)"
            ]
            let data: LikeResponse = try await APIService.shareInitial.requestAPIData(from: urlString, parameters: nil, method: .post, headers: headers)
            return data.statusCode == 200
        } catch {
            print("====Error POST LIKE====")
            print(String(describing: error))
        }
        return false
    }
}
