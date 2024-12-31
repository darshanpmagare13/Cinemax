//
//  SearchVCPresenter.swift
//  Cinemax
//
//  Created by IPS-161 on 01/04/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchVCPresenterProtocol {
    func viewDidload()
    func gotoDetailVC(movieId: Int?)
    func gotoSeeAllVC(page: Int?,searchText: String?,movieId: Int?,seeAllVCInputs: SeeAllVCInputs?)
    func gotoTVShowDetailsVC(tvShowId: Int?)
    func fetchSearchedMoviesAndTVShows(query:String)
    var searchQuery: BehaviorRelay<String> { get set }
    var moviesDatasource : MasterMovieModel? { get set }
    var tvShowsDatasource : MasterMovieModel? { get set }
}

class SearchVCPresenter {
    weak var view: SearchVCProtocol?
    var interactor: SearchVCInteractorProtocol
    var router: SearchVCRouterProtocol
    var searchQuery = BehaviorRelay<String>(value: "")
    var moviesDatasource : MasterMovieModel?
    var tvShowsDatasource : MasterMovieModel?
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()
    init(view: SearchVCProtocol,interactor: SearchVCInteractorProtocol,router: SearchVCRouterProtocol){
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension SearchVCPresenter: SearchVCPresenterProtocol {
    
    func viewDidload(){
        loadDatasource()
    }
    
    func loadDatasource(){
        searchQuery
            .skip(1)
            .map({$0})
            .subscribe({ data in
                if let query = data.element{
                    print(query)
                    self.fetchSearchedMoviesAndTVShows(query:query)
                }
            }).disposed(by: disposeBag)
    }
    
    func fetchSearchedMoviesAndTVShows(query:String){
        dispatchGroup.enter()
        fetchSearchedMovies(searchText: query, page: 1) {
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchSearcedTVShows(searchText: query, page: 1) {
            self.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main){ [weak self] in
            self?.view?.updateUI()
        }
    }
    
    private func fetchSearchedMovies(searchText: String, page: Int,completion:@escaping()->()){
        interactor.fetchMovieSearch(searchText: searchText, page: page)
            .subscribe({ data in
                switch data {
                case.success(let movies):
                    let moviesData = MasterMovieModel(dates: nil, page: movies.page ?? 0, results: movies.results ?? [], totalPages: movies.totalPages ?? 0, totalResults: movies.totalResults ?? 0)
                    self.moviesDatasource = moviesData
                case.failure(let error):
                    print(error)
                }
                completion()
            }).disposed(by: disposeBag)
    }
    
    private func fetchSearcedTVShows(searchText: String, page: Int,completion:@escaping()->()){
        interactor.fetchTVShowSearch(searchText: searchText, page: page)
            .subscribe({ data in
                switch data {
                case.success(let tvShows):
                    let tvShowsData = MasterMovieModel(dates: nil, page: tvShows.page ?? 0, results: tvShows.results ?? [], totalPages: tvShows.totalPages ?? 0, totalResults: tvShows.totalResults ?? 0)
                    self.tvShowsDatasource = tvShowsData
                case.failure(let error):
                    print(error)
                }
                completion()
            }).disposed(by: disposeBag)
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
