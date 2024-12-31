//
//  ProfileVCRouter.swift
//  Cinemax
//
//  Created by IPS-161 on 01/02/24.
//

import Foundation
import UIKit

protocol ProfileVCRouterProtocol {
    func goToSignupVC()
    func goToEditProfileVC()
}

class ProfileVCRouter {
    var viewController: UIViewController
    init(viewController: UIViewController){
        self.viewController = viewController
    }
}

extension ProfileVCRouter: ProfileVCRouterProtocol {
    func goToSignupVC(){
        let signUpVC = SignUpVCBuilder.build(factory: NavigationFactory.build(rootView:))
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = signUpVC
            window.makeKeyAndVisible()
        }
    }
    
    func goToEditProfileVC(){
        let editProfileVC = EditProfileVCBuilder.build()
        viewController.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
}

