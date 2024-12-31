//
//  MovieResultModel.swift
//  Cinemax
//
//  Created by IPS-161 on 13/03/24.
//


import Foundation

// MARK: - MovieResultModel
struct MovieResultModel: Codable {
    let page: Int?
    let results: [MasterMovieModelResult]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
