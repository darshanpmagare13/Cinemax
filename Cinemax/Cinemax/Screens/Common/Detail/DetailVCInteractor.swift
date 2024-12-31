//
//  DetailVCInteractor.swift
//  Cinemax
//
//  Created by IPS-161 on 15/03/24.
//

import Foundation
import RxSwift

protocol DetailVCInteractorProtocol {
    func fetchMovieDetail(movieId:Int) -> Single<MovieDetailsModel>
    func fetchMovieSimilar(movieId:Int,page: Int) -> Single<MovieResultModel>
    func fetchMovieVideos(movieId:Int) -> Single<MovieVideosResponseModel>
    func addMovieToWishlist(movie:CDMoviesModel?,completion:@escaping (Bool) -> Void)
}

class DetailVCInteractor {
    var moviesServiceManager : MoviesServiceManagerProtocol
    var cdMoviesManager : CDMoviesManagerProtocol
    init(moviesServiceManager : MoviesServiceManagerProtocol,cdMoviesManager : CDMoviesManagerProtocol){
        self.moviesServiceManager = moviesServiceManager
        self.cdMoviesManager = cdMoviesManager
    }
}

extension DetailVCInteractor : DetailVCInteractorProtocol {
    func fetchMovieDetail(movieId:Int) -> Single<MovieDetailsModel> {
        return moviesServiceManager.fetchMovieDetail(movieId:movieId)
    }
    func fetchMovieSimilar(movieId:Int,page: Int) -> Single<MovieResultModel>{
        return moviesServiceManager.fetchMovieSimilar(movieId: movieId, page: page)
    }
    func fetchMovieVideos(movieId:Int) -> Single<MovieVideosResponseModel>{
        return moviesServiceManager.fetchMovieVideos(movieId: movieId)
    }
    func addMovieToWishlist(movie:CDMoviesModel?,completion:@escaping (Bool) -> Void){
        cdMoviesManager.addMovieToWishlist(movie:movie) { bool in
            completion(bool)
        }
    }
}
