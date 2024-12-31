//
//  SignUpCredentialVCBuilder.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import Foundation
import UIKit


public final class SignUpCredentialVCBuilder {
    
    static var backButtonPressedClosure : (()->())?
    
    static func build() -> UIViewController {
        let storyboard = UIStoryboard.Authentication
        let signUpCredentialVC = storyboard.instantiateViewController(withIdentifier: "SignUpCredentialVC") as! SignUpCredentialVC
        let interactor = SignUpCredentialVCInteractor(userDataRepositoryManager: UserDataRepositoryManager.shared)
        let router = SignUpCredentialVCRouter(viewController: signUpCredentialVC)
        signUpCredentialVC.presenterProducer = {
            SignUpCredentialVCPresenter(view: signUpCredentialVC, interactor: interactor, router: router, input: $0)
        }
        signUpCredentialVC.title = "Sign Up"
        let backButton = UIBarButtonItem(image: UIImage(named: "BackBtn"), style: .plain, target: self, action: #selector(backButtonPressed))
        signUpCredentialVC.navigationItem.leftBarButtonItem = backButton
        SignUpCredentialVCBuilder.backButtonPressedClosure = { [weak signUpCredentialVC] in
            signUpCredentialVC?.backBtnPressed()
        }
        return signUpCredentialVC
    }
    
    @objc static func backButtonPressed() {
        backButtonPressedClosure?()
    }
    
}
