//
//  WishListVCInteractor.swift
//  Cinemax
//
//  Created by IPS-161 on 04/04/24.
//

import Foundation
import RxSwift

protocol WishListVCInteractorProtocol {
    func fetchMoviesFromWishlist(completion:@escaping(Result<[CDMoviesModel],Error>)->())
    func fetchAllMoviesPagewiseInDetail(movies:[MasterMovieModelResult]) -> Single<[MovieDetailsModel]> 
}

class WishListVCInteractor {
    var movieServiceManager: MoviesServiceManagerProtocol
    var cdMoviesManager : CDMoviesManagerProtocol
    let disposeBag = DisposeBag()
    init(movieServiceManager: MoviesServiceManagerProtocol,cdMoviesManager : CDMoviesManagerProtocol){
        self.movieServiceManager = movieServiceManager
        self.cdMoviesManager = cdMoviesManager
    }
}

extension WishListVCInteractor: WishListVCInteractorProtocol {
    
    func fetchMoviesFromWishlist(completion:@escaping(Result<[CDMoviesModel],Error>)->()){
        cdMoviesManager.fetchMoviesFromWishlist { data in
            completion(data)
        }
    }
    
    func fetchAllMoviesPagewiseInDetail(movies:[MasterMovieModelResult]) -> Single<[MovieDetailsModel]> {
        return Single.create { (single) -> Disposable in
            let disposable = Disposables.create()
            var tempArray = [MovieDetailsModel]()
            let dispatchGroup = DispatchGroup()
            for movie in movies {
                dispatchGroup.enter()
                self.movieServiceManager.fetchMovieDetail(movieId: movie.id ?? 0)
                    .subscribe(onSuccess: { movieDetails in
                        tempArray.append(movieDetails)
                        dispatchGroup.leave()
                    }, onFailure: { error in
                        print(error)
                        // Handle error if needed
                        dispatchGroup.leave()
                    })
                    .disposed(by: self.disposeBag)
            }
            dispatchGroup.notify(queue: .global()) {
                single(.success(tempArray))
            }
            return disposable
        }
    }
    
}
