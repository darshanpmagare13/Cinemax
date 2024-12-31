//
//  OnboardingVCRouter.swift
//  Cinemax
//
//  Created by IPS-161 on 24/01/24.
//

import Foundation
import UIKit

protocol OnboardingVCRouterProtocol {
    func goToLoginVC()
}

class OnboardingVCRouter {
    var viewController: UIViewController
    init(viewController: UIViewController){
        self.viewController = viewController
    }
}

extension OnboardingVCRouter: OnboardingVCRouterProtocol {
    func goToLoginVC() {
        let signUpVC = SignUpVCBuilder.build(factory: NavigationFactory.build(rootView:))
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = signUpVC
            window.makeKeyAndVisible()
        }
    }
}


