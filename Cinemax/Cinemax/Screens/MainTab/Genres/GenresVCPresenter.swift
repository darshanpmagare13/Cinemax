//
//  GenresVCPresenter.swift
//  Cinemax
//
//  Created by IPS-161 on 03/04/24.
//

import Foundation

protocol GenresVCPresenterProtocol {
    func viewDidload()
    func gotoSeeAllVC(genreId: Int?, page: Int?, searchText: String?, movieId: Int?, seeAllVCInputs: SeeAllVCInputs?)
    var genresDatasourceForMovies : [GenresVCEntity] { get set }
    var genresDatasourceForTvshows : [GenresVCEntity] { get set }
}

class GenresVCPresenter {
    weak var view: GenresVCProtocol?
    var interactor: GenresVCInteractorProtocol
    var router: GenresVCRouterProtocol
    var genresDatasourceForMovies = [GenresVCEntity](){
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.view?.updateUI()
            }
        }
    }
    var genresDatasourceForTvshows = [GenresVCEntity]()
    init(view: GenresVCProtocol,interactor: GenresVCInteractorProtocol,router: GenresVCRouterProtocol){
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension GenresVCPresenter: GenresVCPresenterProtocol {
    
    func viewDidload(){
        setupDatasource()
    }
    
    func setupDatasource(){
        let datasource = [GenresVCEntity(genresName: "Action", genresId:28),GenresVCEntity(genresName: "Adventure", genresId:12),GenresVCEntity(genresName: "Animation", genresId:16),GenresVCEntity(genresName: "Comedy", genresId:35),GenresVCEntity(genresName: "Crime", genresId:80),GenresVCEntity(genresName: "Documentary", genresId:99),GenresVCEntity(genresName: "Drama", genresId:18),GenresVCEntity(genresName: "Family", genresId: 10751),GenresVCEntity(genresName: "Fantasy", genresId:14),GenresVCEntity(genresName: "History", genresId: 36),GenresVCEntity(genresName: "Horror", genresId:27),GenresVCEntity(genresName: "Music", genresId: 10402),GenresVCEntity(genresName: "Mystery", genresId:9648),GenresVCEntity(genresName: "Romance", genresId: 10749),GenresVCEntity(genresName: "Science Fiction", genresId:878),GenresVCEntity(genresName: "Thriller", genresId:53),GenresVCEntity(genresName: "War", genresId:10752),GenresVCEntity(genresName: "Western", genresId: 37)]
        let tvShowGenresDataSource = [GenresVCEntity(genresName: "Action & Adventure", genresId: 10759),GenresVCEntity(genresName: "Animation",genresId: 16),GenresVCEntity(genresName: "Comedy", genresId: 35),GenresVCEntity(genresName: "Crime", genresId: 80),GenresVCEntity(genresName: "Documentary", genresId: 99),GenresVCEntity(genresName: "Drama", genresId: 18),GenresVCEntity(genresName: "Family", genresId: 10751),GenresVCEntity(genresName: "Kids", genresId: 10762),GenresVCEntity(genresName: "Mystery", genresId: 9648),GenresVCEntity(genresName: "News", genresId: 10763),GenresVCEntity(genresName: "Reality", genresId: 10764),GenresVCEntity(genresName: "Sci-Fi & Fantasy", genresId: 10765),GenresVCEntity(genresName: "Soap", genresId: 10766),GenresVCEntity(genresName: "Talk", genresId: 10767),GenresVCEntity(genresName: "War & Politics", genresId: 10768),GenresVCEntity(genresName: "Western", genresId: 37)
        ]
        self.genresDatasourceForMovies = datasource
        self.genresDatasourceForTvshows = tvShowGenresDataSource
    }
    
    func gotoSeeAllVC(genreId: Int?, page: Int?, searchText: String?, movieId: Int?, seeAllVCInputs: SeeAllVCInputs?){
        router.gotoSeeAllVC(genreId: genreId, page: page, searchText: searchText, movieId: movieId, seeAllVCInputs: seeAllVCInputs)
    }
    
}
