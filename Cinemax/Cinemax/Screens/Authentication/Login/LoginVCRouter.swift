//
//  LoginVCRouter.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import Foundation
import UIKit

protocol LoginVCRouterProtocol {
    func goToResetPasswordVC()
    func goToMainTabVC()
}

class LoginVCRouter {
    var viewController: UIViewController
    init(viewController: UIViewController){
        self.viewController = viewController
    }
}

extension LoginVCRouter: LoginVCRouterProtocol {
    func goToResetPasswordVC(){
        let resetPasswordVC = ResetPasswordVCBuilder.build()
        viewController.navigationController?.pushViewController(resetPasswordVC, animated: true)
    }
    
    func goToMainTabVC(){
        let mainTabVC = MainTabVCBuilder.build()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = mainTabVC
            window.makeKeyAndVisible()
        }
    }
    
}

