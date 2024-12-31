//
//  TVShowDetailsVCPresenter.swift
//  Cinemax
//
//  Created by IPS-161 on 27/03/24.
//

import Foundation
import RxSwift

protocol TVShowDetailsVCPresenterProtocol {
    func viewDidload()
    func gotoTVShowDetailsVC(tvShowId: Int?)
    func gotoTVShowSimilarVC()
    var tvShowId: Int? { get set }
    var tvShowDetails: TVShowDetailsResponseModel? { get set }
    var tvShowCast: TVShowCastResponseModel? { get set }
    var tvShowTrailer: MovieVideosResponseModel? { get set}
    var tvShowSimilar: TVShowSimilarResponseModel? { get set}
}

class TVShowDetailsVCPresenter {
    weak var view: TVShowDetailsVCProtocol?
    var interactor: TVShowDetailsVCInteractorProtocol
    var router: TVShowDetailsVCRouterProtocol
    var tvShowId: Int?
    var tvShowDetails: TVShowDetailsResponseModel?
    var tvShowCast: TVShowCastResponseModel?
    var tvShowTrailer: MovieVideosResponseModel?
    var tvShowSimilar: TVShowSimilarResponseModel?
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()
    init(view: TVShowDetailsVCProtocol,interactor: TVShowDetailsVCInteractorProtocol,router: TVShowDetailsVCRouterProtocol){
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension TVShowDetailsVCPresenter: TVShowDetailsVCPresenterProtocol {
    
    func viewDidload(){
        view?.registerXibs()
        loadDatasource()
    }
    
    func loadDatasource(){
        dispatchGroup.enter()
        fetchTVShowDetails{
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchTVShowCast{
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchTVShowVideos{
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchTVShowSimilar{
            self.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main){ [weak self] in
            if let tvShowDetails = self?.tvShowDetails {
                self?.view?.updateUI(tvShowDetails: tvShowDetails)
            }
        }
    }
    
    func fetchTVShowDetails(completion:@escaping ()->()){
        if let tvShowId = tvShowId {
            interactor.fetchTVShowDetails(showId: tvShowId)
                .subscribe({ response in
                    switch response {
                    case.success(let showsData):
                        self.tvShowDetails = showsData
                    case.failure(let error):
                        print(error)
                    }
                    completion()
                }).disposed(by: disposeBag)
        }
    }
    
    func fetchTVShowCast(completion:@escaping ()->()){
        if let tvShowId = tvShowId {
            interactor.fetchTVShowCast(showId: tvShowId)
                .subscribe({ response in
                    switch response {
                    case.success(let castData):
                        self.tvShowCast = castData
                    case.failure(let error):
                        print(error)
                    }
                    completion()
                }).disposed(by: disposeBag)
        }
    }
    
    func fetchTVShowVideos(completion:@escaping ()->()){
        if let tvShowId = tvShowId {
            interactor.fetchTVShowVideos(showId: tvShowId)
                .subscribe({ response in
                    switch response {
                    case.success(let tvShowVideosData):
                        self.tvShowTrailer = tvShowVideosData
                    case.failure(let error):
                        print(error)
                    }
                    completion()
                }).disposed(by: disposeBag)
        }
    }
    
    func fetchTVShowSimilar(completion:@escaping ()->()){
        if let tvShowId = tvShowId {
            interactor.fetchTVShowSimilar(similarId: tvShowId, page: 1)
                .subscribe({ response in
                    switch response {
                    case.success(let tvShowSimilarData):
                        print(tvShowSimilarData)
                        self.tvShowSimilar = tvShowSimilarData
                    case.failure(let error):
                        print(error)
                    }
                    completion()
                }).disposed(by: disposeBag)
        }
    }
    
    func gotoTVShowDetailsVC(tvShowId: Int?){
        router.gotoTVShowDetailsVC(tvShowId: tvShowId)
    }
    
    func gotoTVShowSimilarVC(){
        if let tvShowId = tvShowId {
            router.gotoTVShowSimilarVC(tvShowId: tvShowId, page: 1)
        }
    }
    
}
