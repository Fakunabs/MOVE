//
//  State.swift
//  MOVE
//
//  Created by Fakunabs on 08/06/2023.
//

import Foundation

// MARK: - State
struct listStatesResponse: Codable {
    let success: Bool
    let data: [State]
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case success, data
        case statusCode = "status_code"
    }
}

// MARK: - Datum
struct State: Codable {
    let id: Int
    let name: String
    let countryID: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case countryID = "country_id"
    }
}
