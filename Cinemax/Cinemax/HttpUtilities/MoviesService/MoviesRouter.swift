//
//  MoviesRouter.swift
//  Cinemax
//
//  Created by IPS-161 on 05/03/24.
//

import Foundation
import Alamofire

enum MoviesRouter: HttpRouterProtocol {
    
    case moviesUpcoming(page:Int)
    case moviesNowPlaying(page:Int)
    case moviesTopRated(page:Int)
    case moviesPopular(page:Int)
    case movieDetail(movieId:Int)
    case movieSimilar(similarId:Int,page:Int)
    case movieSearch(searchText: String,page:Int)
    case movieVideos(movieId:Int)
    case moviesByGenres(genreId:Int,page:Int)
    case tvShows(page:Int)
    case tvShowDetails(showId:Int)
    case tvShowsCast(showId:Int)
    case tvShowsVideos(showId:Int)
    case tvShowSimilar(similarId:Int,page:Int)
    case tvShowSearch(searchText: String,page:Int)
    case tvShowByGenres(genreId:Int,page:Int)
    
    var baseUrlString: String {
        return "https://api.themoviedb.org/3"
    }
    
    var path: String {
        switch self {
        case .moviesUpcoming(let page):
            return "/movie/upcoming?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page=\(page)"
        case .moviesNowPlaying(let page):
            return "/movie/now_playing?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page=\(page)"
        case .moviesTopRated(let page):
            return "/movie/top_rated?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page=\(page)"
        case .moviesPopular(let page):
            return "/movie/popular?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page=\(page)"
        case .movieDetail(let movieId):
            return "/movie/\(movieId)?api_key=38a73d59546aa378980a88b645f487fc&language=en-US"
        case .movieSimilar(let similarId , let page):
            return "/movie/\(similarId)/similar?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page=\(page)"
        case .movieSearch(let searchText , let page):
            return "/search/movie?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page=\(page)&query=\(searchText)"
        case .movieVideos(let movieId):
            return "/movie/\(movieId)/videos?api_key=38a73d59546aa378980a88b645f487fc&language=en-US"
        case .tvShows(let page):
            return "/tv/on_the_air?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page=\(page)"
        case .tvShowDetails(let showId):
            return "/tv/\(showId)?api_key=38a73d59546aa378980a88b645f487fc&language=en-US"
        case .tvShowsCast(let showId):
            return "/tv/\(showId)/credits?api_key=38a73d59546aa378980a88b645f487fc"
        case .tvShowsVideos(let showId):
            return "/tv/\(showId)/videos?api_key=38a73d59546aa378980a88b645f487fc&language=en-US"
        case .tvShowSimilar(let similarId,let page):
            return "/tv/\(similarId)/similar?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page=\(page)"
        case .tvShowSearch(let searchText,let page):
            return "/search/tv?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page=\(page)&query=\(searchText)"
        case .moviesByGenres(let genreId,let page):
            return "/discover/movie?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&with_genres=\(genreId)"
        case .tvShowByGenres(let genreId,let page):
            return "/discover/tv?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&with_genres=\(genreId)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    func body() throws -> Data? {
        return nil
    }
    
}

// "https://api.themoviedb.org/3/movie/1011985/videos?api_key=38a73d59546aa378980a88b645f487fc&language=en-US")!
//        let trailerURL = URL(string: "https://www.youtube.com/watch?v=69yHznzqCEI")!

//https://api.themoviedb.org/3/tv/on_the_air?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page=1

//https://api.themoviedb.org/3/tv/5579?api_key=38a73d59546aa378980a88b645f487fc&language=en-US

//https://api.themoviedb.org/3/tv/5583/credits?api_key=38a73d59546aa378980a88b645f487fc

//https://api.themoviedb.org/3/tv/5579/videos?api_key=38a73d59546aa378980a88b645f487fc&language=en-US

//"https://api.themoviedb.org/3/movie/top_rated?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page=1"

//https://api.themoviedb.org/3/tv/5583/similar?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page=500

//https://api.themoviedb.org/3/search/tv?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page=1&query=Jumanji

//https://api.themoviedb.org/3/discover/movie?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=28

//https://api.themoviedb.org/3/discover/tv?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=10751
