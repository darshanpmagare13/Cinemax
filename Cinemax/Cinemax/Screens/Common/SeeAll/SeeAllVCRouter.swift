//
//  SeeAllVCRouter.swift
//  Cinemax
//
//  Created by IPS-161 on 19/03/24.
//

import Foundation
import UIKit

protocol SeeAllVCRouterProtocol {
    func gotoDetailVC(movieId: Int?)
    func gotoTVShowDetailsVC(tvShowId: Int?)
}

class SeeAllVCRouter {
    var viewController: UIViewController
    init(viewController: UIViewController){
        self.viewController = viewController
    }
}

extension SeeAllVCRouter: SeeAllVCRouterProtocol {
    func gotoDetailVC(movieId: Int?){
        let detailVC = DetailVCBuilder.build(movieId: movieId)
        viewController.navigationController?.pushViewController(detailVC, animated: true)
    }
    func gotoTVShowDetailsVC(tvShowId: Int?){
        let tvShowDetailsVC = TVShowDetailsVCBuilder.build(tvShowId:tvShowId)
        viewController.navigationController?.pushViewController(tvShowDetailsVC, animated: true)
    }
}
