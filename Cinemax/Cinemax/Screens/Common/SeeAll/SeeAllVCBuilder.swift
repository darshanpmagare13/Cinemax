//
//  SeeAllVCBuilder.swift
//  Cinemax
//
//  Created by IPS-161 on 19/03/24.
//

import Foundation
import UIKit

public final class SeeAllVCBuilder {
    
    static var seeAllVCStack: [SeeAllVC] = []
    static var backButtonPressedClosure : (()->())?
    
    static func build(genreId: Int?,page: Int?,searchText: String?,movieId: Int?,seeAllVCInputs: SeeAllVCInputs?) -> UIViewController {
        let storyboard = UIStoryboard.Common
        let seeAllVC = storyboard.instantiateViewController(withIdentifier: "SeeAllVC") as! SeeAllVC
        let interactor = SeeAllVCInteractor(movieServiceManager: MoviesServiceManager.shared)
        let router = SeeAllVCRouter(viewController: seeAllVC)
        let presenter = SeeAllVCPresenter(view: seeAllVC, interactor: interactor, router: router)
        presenter.page = page
        presenter.searchText = searchText
        presenter.movieId = movieId
        presenter.genreId = genreId
        presenter.seeAllVCInputs = seeAllVCInputs
        if let seeAllVCInputs = seeAllVCInputs {
            switch seeAllVCInputs {
            case .fetchMovieUpcoming(title: let title):
                presenter.moviesHeadline = title
            case .fetchMovieNowPlaying(title: let title):
                presenter.moviesHeadline = title
            case .fetchMovieTopRated(title: let title):
                presenter.moviesHeadline = title
            case .fetchMoviePopular(title: let title):
                presenter.moviesHeadline = title
            case .fetchMovieSimilar(title: let title):
                presenter.moviesHeadline = title
            case .fetchMovieSearch(title: let title):
                presenter.moviesHeadline = title
            case .fetchMoviesByGenres(title: let title):
                presenter.moviesHeadline = title
            case .fetchTVShowByGenres(title: let title):
                presenter.moviesHeadline = title
            }
        }
        seeAllVC.presenter = presenter
        let backButton = UIBarButtonItem(image: UIImage(named: "BackBtn"), style: .plain, target: self, action: #selector(backButtonPressed))
        seeAllVC.navigationItem.leftBarButtonItem = backButton
        SeeAllVCBuilder.backButtonPressedClosure = { [weak seeAllVC] in
            if let lastSeeAllVC = seeAllVCStack.popLast(){
                lastSeeAllVC.backBtnPressed()
            }
        }
        seeAllVCStack.append(seeAllVC)
        return seeAllVC
    }
    
    @objc static func backButtonPressed() {
        backButtonPressedClosure?()
    }
    
}
