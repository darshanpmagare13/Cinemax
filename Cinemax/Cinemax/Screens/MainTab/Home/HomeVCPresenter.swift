//
//  HomeVCPresenter.swift
//  Cinemax
//
//  Created by IPS-161 on 06/02/24.
//

import Foundation
import RxSwift

protocol HomeVCPresenterProtocol {
    func viewDidload()
    func viewWillAppear()
    func loadDataSource()
    func gotoDetailVC(movieId: Int?)
    func gotoSeeAllVC(page: Int?,searchText: String?,movieId: Int?,seeAllVCInputs: SeeAllVCInputs?)
    func gotoTVShowDetailsVC(tvShowId: Int?)
    var movieUpcomingDatasource : MasterMovieModel? { get set }
    var movieNowPlayingDatasource : MasterMovieModel? { get set }
    var movieTopRatedDatasource : MasterMovieModel? { get set }
    var moviePopularDatasource : MasterMovieModel? { get set }
    var tvShowsDatasource : TVShowsResponseModel? { get set }
}

class HomeVCPresenter {
    weak var view: HomeVCProtocol?
    var interactor: HomeVCInteractorProtocol
    var router: HomeVCRouterProtocol
    var movieUpcomingDatasource : MasterMovieModel?
    var movieNowPlayingDatasource : MasterMovieModel?
    var movieTopRatedDatasource : MasterMovieModel?
    var moviePopularDatasource : MasterMovieModel?
    var tvShowsDatasource : TVShowsResponseModel?
    let disposeBag = DisposeBag()
    init(view: HomeVCProtocol,interactor: HomeVCInteractorProtocol,router: HomeVCRouterProtocol){
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension HomeVCPresenter: HomeVCPresenterProtocol {
    
    func viewDidload(){
        loadDataSource()
        view?.bindUI()
        view?.registerXib()
        view?.addRefreshcontroToTableview()
    }
    
    func viewWillAppear(){
        
    }
    
    func loadDataSource(){
        Task {
            self.movieUpcomingDatasource = try? await fetchMovieUpcoming()
            self.movieNowPlayingDatasource = try? await fetchMovieNowPlaying()
            self.movieTopRatedDatasource = try? await fetchMovieTopRated()
            self.moviePopularDatasource = try? await fetchMoviePopular()
            self.tvShowsDatasource = try? await fetchTVShows()
            DispatchQueue.main.async { [weak self] in
                self?.view?.updateUI()
            }
        }
    }
    
    private func fetchMovieUpcoming() async throws -> MasterMovieModel? {
        return try await withCheckedThrowingContinuation { continuation in
            interactor.fetchMovieUpcoming(page: 1)
                .subscribe({ response in
                    switch response {
                    case.success(let movieData):
                        continuation.resume(returning: movieData)
                    case.failure(let error):
                        continuation.resume(throwing: error)
                        print(error)
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    private func fetchMovieNowPlaying() async throws -> MasterMovieModel? {
        return try await withCheckedThrowingContinuation { continuation in
            interactor.fetchMovieNowPlaying(page: 1)
                .subscribe({ response in
                    switch response {
                    case.success(let movieData):
                        continuation.resume(returning: movieData)
                    case.failure(let error):
                        continuation.resume(throwing: error)
                        print(error)
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    private func fetchMovieTopRated() async throws -> MasterMovieModel? {
        return try await withCheckedThrowingContinuation { continuation in
            interactor.fetchMovieTopRated(page: 1)
                .subscribe({ response in
                    switch response {
                    case.success(let movieData):
                        continuation.resume(returning: movieData)
                    case.failure(let error):
                        continuation.resume(throwing: error)
                        print(error)
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    private func fetchMoviePopular() async throws ->  MasterMovieModel? {
        return try await withCheckedThrowingContinuation { continuation in
            interactor.fetchMoviePopular(page: 1)
                .subscribe({ response in
                    switch response {
                    case.success(let movieData):
                        continuation.resume(returning: movieData)
                    case.failure(let error):
                        continuation.resume(throwing: error)
                        print(error)
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    private func fetchTVShows() async throws ->  TVShowsResponseModel? {
        return try await withCheckedThrowingContinuation { continuation in
            interactor.fetchTVShows(page: 1)
                .subscribe({ response in
                    switch response {
                    case.success(let showsData):
                        continuation.resume(returning: showsData)
                    case.failure(let error):
                        continuation.resume(throwing: error)
                        print(error)
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    func gotoDetailVC(movieId: Int?){
        router.gotoDetailVC(movieId: movieId)
    }
    
    func gotoSeeAllVC(page: Int?,searchText: String?,movieId: Int?,seeAllVCInputs: SeeAllVCInputs?){
        router.gotoSeeAllVC(page: page, searchText: searchText, movieId: movieId, seeAllVCInputs: seeAllVCInputs)
    }
    
    func gotoTVShowDetailsVC(tvShowId: Int?){
        router.gotoTVShowDetailsVC(tvShowId: tvShowId)
    }
    
}
