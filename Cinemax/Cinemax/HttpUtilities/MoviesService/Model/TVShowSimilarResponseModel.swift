//
//  TVShowSimilarResponseModel.swift
//  Cinemax
//
//  Created by IPS-161 on 28/03/24.
//

import Foundation

// MARK: - TVShowSimilarResponseModel
struct TVShowSimilarResponseModel: Codable {
    let page: Int?
    let results: [TVShowsResponseModelResult]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
