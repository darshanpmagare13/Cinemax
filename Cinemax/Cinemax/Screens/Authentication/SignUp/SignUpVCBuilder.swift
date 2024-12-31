//
//  SignUpVCBuilder.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import Foundation
import UIKit

public final class SignUpVCBuilder {
    static func build(factory:NavigationFactoryClosure) -> UIViewController {
        let storyboard = UIStoryboard.Authentication
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        let interactor = SignUpVCInteractor(userDataRepositoryManager: UserDataRepositoryManager.shared)
        let router = SignUpVCRouter(viewController: signUpVC)
        let presenter = SignUpVCPresenter(view: signUpVC, interactor: interactor, router: router)
        signUpVC.presenter = presenter
        return factory(signUpVC)
    }
}

