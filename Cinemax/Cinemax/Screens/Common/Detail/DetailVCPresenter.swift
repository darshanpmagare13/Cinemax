//
//  DetailVCPresenter.swift
//  Cinemax
//
//  Created by IPS-161 on 15/03/24.
//

import Foundation
import RxSwift

protocol DetailVCPresenterProtocol {
    func viewDidload()
    func gotoDetailVC(movieId: Int?)
    func gotoSeeAllVC(page: Int?,searchText: String?,movieId: Int?,seeAllVCInputs: SeeAllVCInputs?)
    func addMovieToWishlist()
    func removeMovieFromWishlist()
    func showLoader()
    func hideLoader()
    var movieId : Int? { get set }
    var movieDetail : MovieDetailsModel? { get set }
    var similarMovies : MovieResultModel? { get set }
    var movieVideos : MovieVideosResponseModel? { get set }
    var movieProductionHouses : [ProductionCompany] { get set }
    var wishlistMoviesIds : [Int] { get set }
    var isLoading : Observable<Bool> { get set }
}

class DetailVCPresenter {
    weak var view : DetailVCProtocol?
    var interactor : DetailVCInteractorProtocol
    var router: DetailVCRouterProtocol
    var movieId : Int?
    var movieDetail : MovieDetailsModel?
    var similarMovies : MovieResultModel?
    var movieVideos : MovieVideosResponseModel? {
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.view?.playMovieTrailer()
            }
        }
    }
    var movieProductionHouses = [ProductionCompany]()
    var realmDataRepositoryManager : RealmDataRepositoryManagerProtocol?
    var wishlistMoviesIds = [Int]()
    var isLoading : Observable<Bool> = Observable(value:false)
    let dispatchGroup = DispatchGroup()
    let disposeBag = DisposeBag()
    init(view : DetailVCProtocol,interactor:DetailVCInteractorProtocol,router:DetailVCRouterProtocol,movieId: Int?,realmDataRepositoryManager : RealmDataRepositoryManagerProtocol?){
        self.view = view
        self.interactor = interactor
        self.movieId = movieId
        self.router = router
        self.realmDataRepositoryManager = realmDataRepositoryManager
    }
}

extension DetailVCPresenter : DetailVCPresenterProtocol {
    
    func viewDidload(){
        view?.registerXibs()
        view?.setupFlowlayout()
        view?.bindLoader()
        fetchWishlistMoviesIds()
        loadDatasource()
    }
    
    func loadDatasource(){
        isLoading.value = true
        Task {
            do {
                self.movieDetail = try await fetchMovieData()
                self.similarMovies = try await fetchSimilarMovies()
                self.movieVideos = try await fetchMovieVideos()
                DispatchQueue.main.async { [weak self] in
                    self?.view?.updateSimilarMoviesCollectionviewOutlet()
                    self?.isLoading.value = false
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    func fetchMovieData() async throws -> MovieDetailsModel? {
        guard let movieId = self.movieId else {
            return nil
        }
        return try await withCheckedThrowingContinuation { continuation in
            interactor.fetchMovieDetail(movieId: movieId)
                .subscribe(onSuccess: { movieData in
                    // Pass the movieData to the continuation
                    continuation.resume(returning: movieData)
                    self.movieProductionHouses = movieData.productionCompanies?.compactMap { $0.logoPath != nil ? $0 : nil } ?? []
                    DispatchQueue.main.async { [weak self] in
                        self?.view?.updateUI(movieDetail: movieData)
                    }
                }, onFailure: { error in
                    // Resume the continuation with an error
                    continuation.resume(throwing: error)
                })
                .disposed(by: self.disposeBag)
        }
    }

    
    func fetchSimilarMovies() async throws -> MovieResultModel? {
        guard let movieId = self.movieId else {
            return nil
        }
        return try await withCheckedThrowingContinuation { continuation in
            interactor.fetchMovieSimilar(movieId: movieId, page: 1)
                .subscribe({ response in
                    switch response {
                    case.success(let movieData):
                        print(movieData)
                        continuation.resume(returning: movieData)
                        
                    case.failure(let error):
                        print(error)
                        continuation.resume(throwing: error)
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    func fetchMovieVideos() async throws -> MovieVideosResponseModel? {
        guard let movieId = self.movieId else {
            return nil
        }
        return try await withCheckedThrowingContinuation { continuation in
            interactor.fetchMovieVideos(movieId: movieId)
                .subscribe({ response in
                    switch response {
                    case.success(let movieData):
                        print(movieData)
                        continuation.resume(returning: movieData)
                    case.failure(let error):
                        continuation.resume(throwing: error)
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
    
    func addMovieToWishlist(){
        if let movieId = self.movieId{
            let movie = RealmMoviesModel(movieId: movieId)
            realmDataRepositoryManager?.addMovieToWishlist(movie:movie)
            fetchWishlistMoviesIds()
        }
    }
    
    func removeMovieFromWishlist(){
        if let movieId = self.movieId{
            realmDataRepositoryManager?.deleteMovieFromWishlist(movieId:movieId)
            fetchWishlistMoviesIds()
        }
    }
    
    func fetchWishlistMoviesIds(){
        var tempArray = [Int]()
        if let wishlistMoviesArray = realmDataRepositoryManager?.getMovieFromWishlist() {
            for movie in wishlistMoviesArray {
                if let movieId = movie.movieId.value {
                    tempArray.append(movieId)
                }
            }
            wishlistMoviesIds = tempArray
        }
    }
    
    func showLoader(){
        Loader.shared.showLoader(type: .ballClipRotate, color: .white, background: LoaderVCBackground.withBlur)
    }
    
    func hideLoader(){
        Loader.shared.hideLoader()
    }
    
}
