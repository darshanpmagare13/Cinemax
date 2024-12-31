//
//  TVShowSimilarVCBuilder.swift
//  Cinemax
//
//  Created by IPS-161 on 29/03/24.
//

import Foundation
import UIKit

public final class TVShowSimilarVCBuilder {
    
    static var tvShowSimilarVCStack: [TVShowSimilarVC] = []
    static var backButtonPressedClosure : (()->())?
    
    static func build(tvShowId: Int?,page: Int?) -> UIViewController {
        let storyboard = UIStoryboard.Common
        let tvShowSimilarVC = storyboard.instantiateViewController(withIdentifier: "TVShowSimilarVC") as! TVShowSimilarVC
        let interactor = TVShowSimilarVCInteractor(moviesServiceManager: MoviesServiceManager.shared)
        let router = TVShowSimilarVCRouter(viewController: tvShowSimilarVC)
        let presenter = TVShowSimilarVCPresenter(view: tvShowSimilarVC, interactor: interactor, router: router)
        presenter.tvShowId = tvShowId
        presenter.page = page
        tvShowSimilarVC.presenter = presenter
        let backButton = UIBarButtonItem(image: UIImage(named: "BackBtn"), style: .plain, target: self, action: #selector(backButtonPressed))
        tvShowSimilarVC.navigationItem.leftBarButtonItem = backButton
        TVShowSimilarVCBuilder.backButtonPressedClosure = { [weak tvShowSimilarVC] in
            if let lastTVShowSimilarVC = tvShowSimilarVCStack.popLast(){
                lastTVShowSimilarVC.backBtnPressed()
            }
        }
        tvShowSimilarVCStack.append(tvShowSimilarVC)
        return tvShowSimilarVC
    }
    
    @objc static func backButtonPressed() {
        backButtonPressedClosure?()
    }
    
}
