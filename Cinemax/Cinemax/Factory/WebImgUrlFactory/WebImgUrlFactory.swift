//
//  WebImgUrlFactory.swift
//  Cinemax
//
//  Created by IPS-177  on 19/04/24.
//

import Foundation

enum WebImgUrlTypes{
    case tmdbPosterUrl
}

class WebImgUrlFactory {
    static func createUrl(type:WebImgUrlTypes,inputUrl:String?) -> String {
        guard let inputUrl = inputUrl else {
            return ""
        }
        switch type {
        case.tmdbPosterUrl:
            return "https://image.tmdb.org/t/p/w500\(inputUrl)"
        }
    }
}
