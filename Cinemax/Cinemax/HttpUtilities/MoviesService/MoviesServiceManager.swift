//
//  MoviesServiceManager.swift
//  Cinemax
//
//  Created by IPS-161 on 05/03/24.
//

import Foundation
import Alamofire
import RxSwift

protocol MoviesServiceManagerProtocol {
    func fetchMovieUpcoming(page:Int) -> Single<MasterMovieModel>
    func fetchMovieNowPlaying(page:Int) -> Single<MasterMovieModel>
    func fetchMovieTopRated(page:Int) -> Single<MasterMovieModel>
    func fetchMoviePopular(page:Int) -> Single<MasterMovieModel>
    func fetchMovieDetail(movieId:Int) -> Single<MovieDetailsModel>
    func fetchMovieSimilar(movieId:Int,page: Int) -> Single<MovieResultModel>
    func fetchMovieSearch(searchText:String,page: Int) -> Single<MovieResultModel>
    func fetchMovieVideos(movieId:Int) -> Single<MovieVideosResponseModel>
    func fetchMoviesByGenres(genreId:Int,page:Int) -> Single<MasterMovieModel>
    func fetchTVShows(page:Int) -> Single<TVShowsResponseModel>
    func fetchTVShowDetails(showId:Int) -> Single<TVShowDetailsResponseModel>
    func fetchTVShowCast(showId:Int) -> Single<TVShowCastResponseModel>
    func fetchTVShowVideos(showId:Int) -> Single<MovieVideosResponseModel>
    func fetchTVShowSimilar(similarId: Int, page: Int) -> Single<TVShowSimilarResponseModel>
    func fetchTVShowSearch(searchText:String,page: Int) -> Single<MovieResultModel>
    func fetchTVShowByGenres(genreId:Int,page:Int) -> Single<MasterMovieModel>
}

final class MoviesServiceManager {
    lazy var movieService = MoviesService()
    static let shared = MoviesServiceManager()
    private init(){}
}

extension MoviesServiceManager : MoviesServiceManagerProtocol  {
    
    func fetchMovieUpcoming(page:Int) -> Single<MasterMovieModel> {
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.moviesUpcoming(page: page).request(service: self.movieService)
                    .responseDecodable(of: MasterMovieModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchMovieNowPlaying(page:Int) -> Single<MasterMovieModel> {
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.moviesNowPlaying(page: page).request(service: self.movieService)
                    .responseDecodable(of: MasterMovieModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchMovieTopRated(page:Int) -> Single<MasterMovieModel> {
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.moviesTopRated(page: page).request(service: self.movieService)
                    .responseDecodable(of: MasterMovieModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchMoviePopular(page:Int) -> Single<MasterMovieModel> {
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.moviesPopular(page: page).request(service: self.movieService)
                    .responseDecodable(of: MasterMovieModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchMovieDetail(movieId:Int) -> Single<MovieDetailsModel> {
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.movieDetail(movieId: movieId).request(service: self.movieService)
                    .responseDecodable(of: MovieDetailsModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchMovieSimilar(movieId:Int,page: Int) -> Single<MovieResultModel> {
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.movieSimilar(similarId: movieId, page:page).request(service: self.movieService)
                    .responseDecodable(of: MovieResultModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchMovieSearch(searchText:String,page: Int) -> Single<MovieResultModel> {
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.movieSearch(searchText: searchText, page:page).request(service: self.movieService)
                    .responseDecodable(of: MovieResultModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchMovieVideos(movieId:Int) -> Single<MovieVideosResponseModel> {
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.movieVideos(movieId: movieId).request(service: self.movieService)
                    .responseDecodable(of: MovieVideosResponseModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchTVShows(page:Int) -> Single<TVShowsResponseModel> {
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.tvShows(page: page).request(service: self.movieService)
                    .responseDecodable(of: TVShowsResponseModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchTVShowDetails(showId:Int) -> Single<TVShowDetailsResponseModel> {
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.tvShowDetails(showId: showId).request(service: self.movieService)
                    .responseDecodable(of: TVShowDetailsResponseModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchTVShowCast(showId:Int) -> Single<TVShowCastResponseModel>{
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.tvShowsCast(showId: showId).request(service: self.movieService)
                    .responseDecodable(of: TVShowCastResponseModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchTVShowVideos(showId:Int) -> Single<MovieVideosResponseModel>{
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.tvShowsVideos(showId: showId).request(service: self.movieService)
                    .responseDecodable(of:MovieVideosResponseModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchTVShowSimilar(similarId: Int, page: Int) -> Single<TVShowSimilarResponseModel>{
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.tvShowSimilar(similarId: similarId, page: page).request(service: self.movieService)
                    .responseDecodable(of:TVShowSimilarResponseModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchTVShowSearch(searchText:String,page: Int) -> Single<MovieResultModel> {
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.tvShowSearch(searchText: searchText, page:page).request(service: self.movieService)
                    .responseDecodable(of: MovieResultModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchMoviesByGenres(genreId:Int,page:Int) -> Single<MasterMovieModel>{
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.moviesByGenres(genreId: genreId, page: page).request(service: self.movieService)
                    .responseDecodable(of: MasterMovieModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
    func fetchTVShowByGenres(genreId:Int,page:Int) -> Single<MasterMovieModel>{
        return Single.create(subscribe:{ (single) -> Disposable in
            let disposables = Disposables.create()
            do{
                try MoviesRouter.tvShowByGenres(genreId: genreId, page: page).request(service: self.movieService)
                    .responseDecodable(of: MasterMovieModel.self, queue: DispatchQueue.global(qos: .utility), completionHandler: { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch let error{
                single(.failure(error))
            }
            return disposables
        })
    }
    
}
