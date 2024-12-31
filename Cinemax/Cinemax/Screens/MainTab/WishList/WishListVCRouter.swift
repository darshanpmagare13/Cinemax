//
//  WishListVCRouter.swift
//  Cinemax
//
//  Created by IPS-161 on 04/04/24.
//

import Foundation
import UIKit

protocol WishListVCRouterProtocol {
    func gotoDetailVC(movieId: Int?)
}

class WishListVCRouter {
    var viewController: UIViewController
    init(viewController: UIViewController){
        self.viewController = viewController
    }
}

extension WishListVCRouter: WishListVCRouterProtocol {
    func gotoDetailVC(movieId: Int?){
        let detailVC = DetailVCBuilder.build(movieId: movieId)
        viewController.navigationController?.pushViewController(detailVC, animated: true)
    }
}
