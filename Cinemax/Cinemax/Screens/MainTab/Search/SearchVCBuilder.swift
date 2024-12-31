//
//  SearchVCBuilder.swift
//  Cinemax
//
//  Created by IPS-161 on 01/02/24.
//

import Foundation
import UIKit

public final class SearchVCBuilder {
    static func build(factor:NavigationFactoryClosure) -> UIViewController {
        let storyboard = UIStoryboard.Search
        let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        let router = SearchVCRouter(viewController: searchVC)
        let interactor = SearchVCInteractor(moviesServiceManager: MoviesServiceManager.shared)
        let presenter = SearchVCPresenter(view: searchVC, interactor: interactor, router: router)
        searchVC.presenter = presenter
        return factor(searchVC)
    }
}

