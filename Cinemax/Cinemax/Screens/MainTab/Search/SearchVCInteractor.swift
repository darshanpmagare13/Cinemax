//
//  SearchVCInteractor.swift
//  Cinemax
//
//  Created by IPS-161 on 01/04/24.
//

import Foundation
import RxSwift

protocol SearchVCInteractorProtocol {
    func fetchMovieSearch(searchText:String,page: Int) -> Single<MovieResultModel>
    func fetchTVShowSearch(searchText:String,page: Int) -> Single<MovieResultModel>
}

class SearchVCInteractor {
    var moviesServiceManager : MoviesServiceManagerProtocol
    init(moviesServiceManager : MoviesServiceManagerProtocol){
        self.moviesServiceManager = moviesServiceManager
    }
}

extension SearchVCInteractor: SearchVCInteractorProtocol {
    func fetchMovieSearch(searchText:String,page: Int) -> Single<MovieResultModel>{
        return moviesServiceManager.fetchMovieSearch(searchText: searchText, page: page)
    }
    func fetchTVShowSearch(searchText:String,page: Int) -> Single<MovieResultModel>{
        return moviesServiceManager.fetchTVShowSearch(searchText: searchText, page: page)
    }
}
