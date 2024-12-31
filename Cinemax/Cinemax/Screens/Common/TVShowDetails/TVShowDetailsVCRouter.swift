//
//  TVShowDetailsVCRouter.swift
//  Cinemax
//
//  Created by IPS-161 on 27/03/24.
//

import Foundation
import UIKit

protocol TVShowDetailsVCRouterProtocol {
    func gotoTVShowDetailsVC(tvShowId: Int?)
    func gotoTVShowSimilarVC(tvShowId: Int?, page: Int?)
}

class TVShowDetailsVCRouter {
    var viewController: UIViewController
    init(viewController: UIViewController){
        self.viewController = viewController
    }
}

extension TVShowDetailsVCRouter: TVShowDetailsVCRouterProtocol {
    func gotoTVShowDetailsVC(tvShowId: Int?){
        let tvShowDetailsVC = TVShowDetailsVCBuilder.build(tvShowId:tvShowId)
        viewController.navigationController?.pushViewController(tvShowDetailsVC, animated: true)
    }
    func gotoTVShowSimilarVC(tvShowId: Int?, page: Int?){
        let tvShowSimilarVC = TVShowSimilarVCBuilder.build(tvShowId: tvShowId, page: page)
        viewController.navigationController?.pushViewController(tvShowSimilarVC, animated: true)
    }
}
