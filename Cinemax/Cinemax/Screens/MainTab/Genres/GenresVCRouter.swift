//
//  GenresVCRouter.swift
//  Cinemax
//
//  Created by IPS-161 on 03/04/24.
//

import Foundation
import UIKit

protocol GenresVCRouterProtocol {
    func gotoSeeAllVC(genreId: Int?, page: Int?, searchText: String?, movieId: Int?, seeAllVCInputs: SeeAllVCInputs?)
}

class GenresVCRouter {
    var viewController: UIViewController
    init(viewController: UIViewController){
        self.viewController = viewController
    }
}

extension GenresVCRouter: GenresVCRouterProtocol {
    func gotoSeeAllVC(genreId: Int?, page: Int?, searchText: String?, movieId: Int?, seeAllVCInputs: SeeAllVCInputs?){
        let seeAllVC = SeeAllVCBuilder.build(genreId: genreId, page: page, searchText: searchText, movieId: movieId, seeAllVCInputs: seeAllVCInputs)
        viewController.navigationController?.pushViewController(seeAllVC, animated: true)
    }
}
