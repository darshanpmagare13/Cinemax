//
//  SignUpCredentialVCRouter.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import Foundation
import UIKit

protocol SignUpCredentialVCRouterProtocol {
    func goToMainTabVC()
}

class SignUpCredentialVCRouter {
    var viewController: UIViewController
    init(viewController: UIViewController){
        self.viewController = viewController
    }
}

extension SignUpCredentialVCRouter: SignUpCredentialVCRouterProtocol {
    
    func goToMainTabVC(){
        let mainTabVC = MainTabVCBuilder.build()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = mainTabVC
            window.makeKeyAndVisible()
        }
    }
    
}

