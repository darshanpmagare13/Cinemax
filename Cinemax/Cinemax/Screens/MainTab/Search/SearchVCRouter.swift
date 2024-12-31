//
//  SearchVCRouter.swift
//  Cinemax
//
//  Created by IPS-161 on 01/04/24.
//

import Foundation
import UIKit

protocol SearchVCRouterProtocol {
    func gotoDetailVC(movieId: Int?)
    func gotoSeeAllVC(page: Int?,searchText: String?,movieId: Int?,seeAllVCInputs: SeeAllVCInputs?)
    func gotoTVShowDetailsVC(tvShowId: Int?)
}

class SearchVCRouter {
    var viewController: UIViewController
    init(viewController: UIViewController){
        self.viewController = viewController
    }
}

extension SearchVCRouter: SearchVCRouterProtocol {
    func gotoDetailVC(movieId: Int?){
        let detailVC = DetailVCBuilder.build(movieId: movieId)
        viewController.navigationController?.pushViewController(detailVC, animated: true)
    }
    func gotoSeeAllVC(page: Int?,searchText: String?,movieId: Int?,seeAllVCInputs: SeeAllVCInputs?){
        let seeAllVC = SeeAllVCBuilder.build(genreId: 0, page: page, searchText: searchText, movieId: movieId, seeAllVCInputs: seeAllVCInputs)
        viewController.navigationController?.pushViewController(seeAllVC, animated: true)
    }
    func gotoTVShowDetailsVC(tvShowId: Int?){
        let tvShowDetailsVC = TVShowDetailsVCBuilder.build(tvShowId:tvShowId)
        viewController.navigationController?.pushViewController(tvShowDetailsVC, animated: true)
    }
}

