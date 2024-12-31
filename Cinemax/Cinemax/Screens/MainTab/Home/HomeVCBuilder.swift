//
//  HomeVCBuilder.swift
//  Cinemax
//
//  Created by IPS-161 on 01/02/24.
//

import Foundation
import UIKit

public final class HomeVCBuilder {
    static func build(factor:NavigationFactoryClosure) -> UIViewController {
        let storyboard = UIStoryboard.Home
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let moviesServiceManager = MoviesServiceManager.shared
        let interactor = HomeVCInteractor(moviesServiceManager: moviesServiceManager)
        let router = HomeVCRouter(viewController: homeVC)
        let presenter = HomeVCPresenter(view: homeVC, interactor: interactor, router: router)
        homeVC.presenter = presenter
        return factor(homeVC)
    }
}
