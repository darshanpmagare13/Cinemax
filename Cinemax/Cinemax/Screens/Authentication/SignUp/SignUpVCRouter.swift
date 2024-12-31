//
//  SignUpVCRouter.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import Foundation
import UIKit

protocol SignUpVCRouterProtocol {
    func goToSignUpCredentialVC()
    func goToLoginVC()
    func goToMainTabVC()
}

class SignUpVCRouter {
    var viewController: UIViewController
    init(viewController: UIViewController){
        self.viewController = viewController
    }
}

extension SignUpVCRouter: SignUpVCRouterProtocol {
    func goToSignUpCredentialVC(){
        let signUpCredentialVC = SignUpCredentialVCBuilder.build()
        viewController.navigationController?.pushViewController(signUpCredentialVC, animated: true)
    }
    
    func goToLoginVC(){
        let loginVC = LoginVCBuilder.build()
        viewController.navigationController?.pushViewController(loginVC, animated: true)
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

