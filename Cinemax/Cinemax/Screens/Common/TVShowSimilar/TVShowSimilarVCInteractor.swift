//
//  TVShowSimilarVCInteractor.swift
//  Cinemax
//
//  Created by IPS-161 on 29/03/24.
//

import Foundation
import RxSwift

protocol TVShowSimilarVCInteractorProtocol {
    func fetchTVShowSimilar(similarId: Int, page: Int) -> Single<TVShowSimilarResponseModel>
}

class TVShowSimilarVCInteractor {
    var moviesServiceManager : MoviesServiceManagerProtocol
    init(moviesServiceManager : MoviesServiceManagerProtocol){
        self.moviesServiceManager = moviesServiceManager
    }
}

extension TVShowSimilarVCInteractor: TVShowSimilarVCInteractorProtocol {
    func fetchTVShowSimilar(similarId: Int, page: Int) -> Single<TVShowSimilarResponseModel>{
        return moviesServiceManager.fetchTVShowSimilar(similarId: similarId, page: page)
    }
}
