//
//  LoginVCBuilder.swift
//  Cinemax
//
//  Created by IPS-161 on 25/01/24.
//

import Foundation
import UIKit

public final class LoginVCBuilder {
    
    static var backButtonPressedClosure : (()->())?
    
    static func build() -> UIViewController {
        let storyboard = UIStoryboard.Authentication
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let interactor = LoginVCInteractor(userDataRepositoryManager: UserDataRepositoryManager.shared)
        let router = LoginVCRouter(viewController: loginVC)
        loginVC.presenterProducer = {
            LoginVCPresenter(view: loginVC, interactor: interactor, router: router, input: $0)
        }
        loginVC.title = "Login"
        let backButton = UIBarButtonItem(image: UIImage(named: "BackBtn"), style: .plain, target: self, action: #selector(backButtonPressed))
        loginVC.navigationItem.leftBarButtonItem = backButton
        LoginVCBuilder.backButtonPressedClosure = { [weak loginVC] in
            loginVC?.backBtnPressed()
        }
        
        return loginVC
    }
    
    @objc static func backButtonPressed() {
        backButtonPressedClosure?()
    }
    
}
