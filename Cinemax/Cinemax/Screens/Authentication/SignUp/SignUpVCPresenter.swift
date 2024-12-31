//
//  SignUpVCPresenter.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import Foundation
import UIKit

protocol SignUpVCPresenterProtocol {
    func viewDidload()
    func goToSignUpCredentialVC()
    func goToLoginVC()
    func signinWithGoogle(view: UIViewController)
    func goToMainTabVC()
}

class SignUpVCPresenter {
    weak var view: SignUpVCProtocol?
    var interactor: SignUpVCInteractorProtocol
    var router: SignUpVCRouterProtocol
    init(view: SignUpVCProtocol,interactor: SignUpVCInteractorProtocol,router: SignUpVCRouterProtocol){
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension SignUpVCPresenter: SignUpVCPresenterProtocol {
    func viewDidload(){
        
    }
    
    func goToSignUpCredentialVC(){
        router.goToSignUpCredentialVC()
    }
    
    func goToLoginVC(){
        router.goToLoginVC()
    }
    
    func signinWithGoogle(view: UIViewController){
        showLoader()
        interactor.signinWithGoogle(view: view) { result in
            switch result {
            case.success(let bool):
                print(bool)
                self.interactor.getGoogleUserProfile {
                    DispatchQueue.main.async { [weak self] in
                        self?.hideLoader()
                        self?.goToMainTabVC()
                    }
                }
            case.failure(let error):
                print(error)
                self.hideLoader()
            }
        }
    }
    
    func goToMainTabVC(){
        router.goToMainTabVC()
    }
    
    private func showLoader(){
        Loader.shared.showLoader(type: .lineScale, color: .white, background: LoaderVCBackground.withoutBlur)
    }
    
    private func hideLoader(){
        Loader.shared.hideLoader()
    }
    
}
