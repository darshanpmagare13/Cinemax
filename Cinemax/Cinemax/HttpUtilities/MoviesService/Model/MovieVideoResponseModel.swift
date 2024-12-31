//
//  MovieVideoResponseModel.swift
//  Cinemax
//
//  Created by IPS-161 on 22/03/24.
//

import Foundation

// MARK: - MovieVideosResponseModel

struct MovieVideosResponseModel: Codable {
    let id: Int?
    let results: [Trailer]?
}

struct Trailer: Codable {
    let iso_639_1: String?
    let iso_3166_1: String?
    let name: String?
    let key: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let published_at: String?
    let trailerId: String?
    
    enum CodingKeys: String, CodingKey {
        case iso_639_1, iso_3166_1, name, key, site, size, type, official
        case published_at, trailerId = "id"
    }
}
