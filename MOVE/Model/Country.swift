//
//  Country.swift
//  MOVE
//
//  Created by Fakunabs on 08/06/2023.
//

import Foundation

// MARK: - listCountries
struct ListCountriesResponse: Codable {
    let success: Bool
    let data: [Country]
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case success, data
        case statusCode = "status_code"
    }
}

// MARK: - Country
struct Country: Codable {
    let id: Int
    let name: String
}


