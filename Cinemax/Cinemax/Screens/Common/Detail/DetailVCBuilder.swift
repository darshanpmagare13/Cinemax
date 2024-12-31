//
//  DetailVCBuilder.swift
//  Cinemax
//
//  Created by IPS-161 on 14/03/24.
//

import Foundation
import UIKit

public final class DetailVCBuilder {
    
    static var detailVCStack: [DetailVC] = []
    static var backButtonPressedClosure : (()->())?
    
    static func build(movieId: Int?) -> UIViewController {
        let storyboard = UIStoryboard.Common
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        let interactor = DetailVCInteractor(moviesServiceManager: MoviesServiceManager.shared,
                                            cdMoviesManager: CDMoviesManager.shared)
        let router = DetailVCRouter(viewController: detailVC)
        let presenter = DetailVCPresenter(view: detailVC, interactor: interactor, router: router, movieId: movieId, realmDataRepositoryManager: RealmDataRepositoryManager.shared)
        detailVC.presenter = presenter
        let backButton = UIBarButtonItem(image: UIImage(named: "BackBtn"), style: .plain, target: self, action: #selector(backButtonPressed))
        detailVC.navigationItem.leftBarButtonItem = backButton
        DetailVCBuilder.backButtonPressedClosure = { [weak detailVC] in
            if let lastDetailVC = detailVCStack.popLast(){
                lastDetailVC.backBtnPressed()
            }
        }
        detailVCStack.append(detailVC)
        return detailVC
    }
    
    @objc static func backButtonPressed() {
        backButtonPressedClosure?()
    }
    
}
