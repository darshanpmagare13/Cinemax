//
//  WishListVCBuilder.swift
//  Cinemax
//
//  Created by IPS-161 on 03/04/24.
//

import Foundation
import UIKit

public final class WishListVCBuilder {
    static func build(factor:NavigationFactoryClosure) -> UIViewController {
        let storyboard = UIStoryboard.WishList
        let wishListVC = storyboard.instantiateViewController(withIdentifier: "WishListVC") as! WishListVC
        let router = WishListVCRouter(viewController: wishListVC)
        let interactor = WishListVCInteractor(movieServiceManager: MoviesServiceManager.shared, cdMoviesManager: CDMoviesManager.shared)
        let presenter = WishListVCPresenter(view: wishListVC, interactor: interactor, router: router)
        wishListVC.presenter = presenter
        return factor(wishListVC)
    }
}
