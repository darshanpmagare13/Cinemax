//
//  SeeAllVCInteractor.swift
//  Cinemax
//
//  Created by IPS-161 on 19/03/24.
//

import Foundation
import RxSwift

enum SeeAllVCInputs {
    case fetchMovieUpcoming(title:String)
    case fetchMovieNowPlaying(title:String)
    case fetchMovieTopRated(title:String)
    case fetchMoviePopular(title:String)
    case fetchMovieSimilar(title:String)
    case fetchMovieSearch(title:String)
    case fetchMoviesByGenres(title:String)
    case fetchTVShowByGenres(title:String)
}


protocol SeeAllVCInteractorProtocol {
    func fetchAllMoviesPagewise(seeAllVCInputs:SeeAllVCInputs?,movieId:Int?,searchText:String?,page: Int?,genreId:Int?) -> Single<[MasterMovieModelResult]>
    func fetchAllMoviesPagewiseInDetail(movies:[MasterMovieModelResult]) -> Single<[MovieDetailsModel]>
    func fetchAllTVShowsPagewiseInDetail(tvShows:[MasterMovieModelResult]) -> Single<[TVShowDetailsResponseModel]>
}

class SeeAllVCInteractor {
    var movieServiceManager: MoviesServiceManagerProtocol
    let disposeBag = DisposeBag()
    init(movieServiceManager: MoviesServiceManagerProtocol){
        self.movieServiceManager = movieServiceManager
    }
}

extension SeeAllVCInteractor: SeeAllVCInteractorProtocol  {
    func fetchAllMoviesPagewise(seeAllVCInputs:SeeAllVCInputs?,movieId:Int?,searchText:String?,page: Int?,genreId:Int?) -> Single<[MasterMovieModelResult]> {
        return Single.create { (single) -> Disposable in
            let disposable = Disposables.create()
            guard let seeAllVCInputs = seeAllVCInputs,
                  let movieId = movieId,
                  let searchText = searchText,
                  let page = page,
                  let genreId = genreId else {
                single(.failure(fatalError()))
                return disposable
            }
            switch seeAllVCInputs {
                
            case .fetchMovieUpcoming:
                self.movieServiceManager.fetchMovieUpcoming(page: page)
                    .subscribe({ data in
                        switch data {
                        case.success(let movieData):
                            single(.success(movieData.results))
                        case.failure(let error):
                            single(.failure(error))
                        }
                    }).disposed(by: self.disposeBag)
                
            case .fetchMovieNowPlaying:
                self.movieServiceManager.fetchMovieNowPlaying(page: page)
                    .subscribe({ data in
                        switch data {
                        case.success(let movieData):
                            single(.success(movieData.results))
                        case.failure(let error):
                            single(.failure(error))
                        }
                    }).disposed(by: self.disposeBag)
                
            case .fetchMovieTopRated:
                self.movieServiceManager.fetchMovieTopRated(page: page)
                    .subscribe({ data in
                        switch data {
                        case.success(let movieData):
                            single(.success(movieData.results))
                        case.failure(let error):
                            single(.failure(error))
                        }
                    }).disposed(by: self.disposeBag)
                
            case .fetchMoviePopular:
                self.movieServiceManager.fetchMoviePopular(page: page)
                    .subscribe({ data in
                        switch data {
                        case.success(let movieData):
                            single(.success(movieData.results))
                        case.failure(let error):
                            single(.failure(error))
                        }
                    }).disposed(by: self.disposeBag)
                
            case .fetchMovieSimilar:
                self.movieServiceManager.fetchMovieSimilar(movieId: movieId, page: page)
                    .subscribe({ data in
                        switch data {
                        case.success(let movieData):
                            single(.success(movieData.results ?? []))
                        case.failure(let error):
                            single(.failure(error))
                        }
                    }).disposed(by: self.disposeBag)
                
            case .fetchMovieSearch:
                self.movieServiceManager.fetchMovieSearch(searchText: searchText, page: page)
                    .subscribe({ data in
                        switch data {
                        case.success(let movieData):
                            single(.success(movieData.results ?? []))
                        case.failure(let error):
                            single(.failure(error))
                        }
                    }).disposed(by: self.disposeBag)
                
            case .fetchMoviesByGenres:
                self.movieServiceManager.fetchMoviesByGenres(genreId: genreId, page: page)
                    .subscribe({ data in
                        switch data {
                        case.success(let movieData):
                            single(.success(movieData.results ?? []))
                        case.failure(let error):
                            single(.failure(error))
                        }
                    }).disposed(by: self.disposeBag)
            case .fetchTVShowByGenres:
                self.movieServiceManager.fetchTVShowByGenres(genreId: genreId, page: page)
                    .subscribe({ data in
                        switch data {
                        case.success(let movieData):
                            single(.success(movieData.results ?? []))
                        case.failure(let error):
                            single(.failure(error))
                        }
                    }).disposed(by: self.disposeBag)
            }
            return disposable
        }
    }
    
    func fetchAllMoviesPagewiseInDetail(movies: [MasterMovieModelResult]) -> Single<[MovieDetailsModel]> {
        // Create an array of Single<MovieDetailsModel> for each movie fetch
        let movieDetailsSingles: [Single<MovieDetailsModel>] = movies.compactMap { movie in
            guard let movieId = movie.id else { return nil }
            // Return a Single for fetching each movie detail
            return self.movieServiceManager.fetchMovieDetail(movieId: movieId)
        }
        // Use Single.zip to wait for all Single instances to complete and collect results
        return Single.zip(movieDetailsSingles)
    }

    
    
    func fetchAllTVShowsPagewiseInDetail(tvShows: [MasterMovieModelResult]) -> Single<[TVShowDetailsResponseModel]> {
        // Create an array of Single<TVShowDetailsResponseModel> for each TV show fetch
        let tvShowDetailsSingles: [Single<TVShowDetailsResponseModel>] = tvShows.compactMap { tvShow in
            guard let showId = tvShow.id else { return nil }
            // Return a Single for fetching each TV show detail
            return self.movieServiceManager.fetchTVShowDetails(showId: showId)
        }

        // Use Single.zip to wait for all Single instances to complete and collect results
        return Single.zip(tvShowDetailsSingles)
    }

    
    
}
