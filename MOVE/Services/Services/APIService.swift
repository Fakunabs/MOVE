//
//  APIMove.swift
//  MOVE
//
//  Created by Vinh Nguyen on 26/04/2023.
//

import Foundation
import Alamofire

enum HttpError : Error {
    case invalidUrl
}

class APIService {
    
    static let shareInitial = APIService()
    
    func requestAPIData<T: Decodable>(from path: String, parameters: Parameters?, method: HTTPMethod, headers: HTTPHeaders?) async throws -> T {
        
        guard let url = URL(string: path) else {
            throw HttpError.invalidUrl
        }
        let encoding: ParameterEncoding = URLEncoding.default
        
        return try await withUnsafeThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch(response.result) {
                case .success(let data):
                    switch response.response?.statusCode {
                    case 200,201:
                        continuation.resume(returning: data)
                    case 500:
                        print("Server Error")
                        break
                    default:
                        print("Unknown Error")
                        break
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
