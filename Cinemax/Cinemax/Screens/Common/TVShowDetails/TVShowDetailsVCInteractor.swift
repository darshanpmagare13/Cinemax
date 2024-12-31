//
//  TVShowDetailsVCInteractor.swift
//  Cinemax
//
//  Created by IPS-161 on 27/03/24.
//

import Foundation
import RxSwift

protocol TVShowDetailsVCInteractorProtocol {
    func fetchTVShowDetails(showId:Int) -> Single<TVShowDetailsResponseModel>
    func fetchTVShowCast(showId:Int) -> Single<TVShowCastResponseModel>
    func fetchTVShowVideos(showId:Int) -> Single<MovieVideosResponseModel>
    func fetchTVShowSimilar(similarId: Int, page: Int) -> Single<TVShowSimilarResponseModel>
}

class TVShowDetailsVCInteractor {
    var moviesServiceManager : MoviesServiceManagerProtocol
    init(moviesServiceManager : MoviesServiceManagerProtocol){
        self.moviesServiceManager = moviesServiceManager
    }
}

extension TVShowDetailsVCInteractor: TVShowDetailsVCInteractorProtocol {
    func fetchTVShowDetails(showId:Int) -> Single<TVShowDetailsResponseModel>{
        return moviesServiceManager.fetchTVShowDetails(showId: showId)
    }
    func fetchTVShowCast(showId:Int) -> Single<TVShowCastResponseModel>{
        return moviesServiceManager.fetchTVShowCast(showId: showId)
    }
    func fetchTVShowVideos(showId:Int) -> Single<MovieVideosResponseModel>{
        return moviesServiceManager.fetchTVShowVideos(showId: showId)
    }
    func fetchTVShowSimilar(similarId: Int, page: Int) -> Single<TVShowSimilarResponseModel>{
        return moviesServiceManager.fetchTVShowSimilar(similarId: similarId, page: page)
    }
}
