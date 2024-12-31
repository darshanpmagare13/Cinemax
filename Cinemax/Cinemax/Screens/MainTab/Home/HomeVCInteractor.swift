import Foundation
import RxSwift

protocol HomeVCInteractorProtocol {
    func fetchMovieUpcoming(page:Int) -> Single<MasterMovieModel>
    func fetchMovieNowPlaying(page:Int) -> Single<MasterMovieModel>
    func fetchMovieTopRated(page:Int) -> Single<MasterMovieModel>
    func fetchMoviePopular(page:Int) -> Single<MasterMovieModel>
    func fetchTVShows(page:Int) -> Single<TVShowsResponseModel>
}

class HomeVCInteractor {
    var moviesServiceManager : MoviesServiceManagerProtocol
    init(moviesServiceManager : MoviesServiceManagerProtocol){
        self.moviesServiceManager = moviesServiceManager
    }
}

extension HomeVCInteractor: HomeVCInteractorProtocol {
    func fetchMovieUpcoming(page:Int) -> Single<MasterMovieModel> {
        return moviesServiceManager.fetchMovieUpcoming(page: page)
    }
    func fetchMovieNowPlaying(page:Int) -> Single<MasterMovieModel> {
        return moviesServiceManager.fetchMovieNowPlaying(page: page)
    }
    func fetchMovieTopRated(page:Int) -> Single<MasterMovieModel> {
        return moviesServiceManager.fetchMovieTopRated(page: page)
    }
    func fetchMoviePopular(page:Int) -> Single<MasterMovieModel> {
        return moviesServiceManager.fetchMoviePopular(page: page)
    }
    
    func fetchTVShows(page:Int) -> Single<TVShowsResponseModel>{
        return moviesServiceManager.fetchTVShows(page: page)
    }
}

