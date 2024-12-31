//
//  TVShowCastResponseModel.swift
//  Cinemax
//
//  Created by IPS-161 on 27/03/24.
//

import Foundation

struct TVShowCastResponseModel: Codable {
    let cast: [TVShowCast]?
    let crew: [TVShowCrew]?
    let id: Int?
}

struct TVShowCast: Codable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let character: String?
    let creditId: String?
    let order: Int?
}

struct TVShowCrew: Codable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let creditId: String?
    let department: String?
    let job: String?
}
