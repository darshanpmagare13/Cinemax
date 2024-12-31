//
//  ProfileVCPresenter.swift
//  Cinemax
//
//  Created by IPS-161 on 01/02/24.
//

import Foundation

protocol ProfileVCPresenterProtocol {
    func viewDidload()
    func viewWillAppear()
    func currentUserLogout()
    func goToSignupVC()
    func goToEditProfileVC()
}

class ProfileVCPresenter {
    weak var view: ProfileVCProtocol?
    var interactor: ProfileVCInteractorProtocol
    var router: ProfileVCRouterProtocol
    init(view: ProfileVCProtocol,interactor: ProfileVCInteractorProtocol,router: ProfileVCRouterProtocol){
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ProfileVCPresenter: ProfileVCPresenterProtocol {
    
    func viewDidload(){
        view?.bindUI()
    }
    
    func viewWillAppear(){
        
    }
    
    func currentUserLogout(){
        Loader.shared.showLoader(type: .lineScale, color: .white, background: LoaderVCBackground.withoutBlur)
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { [weak self] in
            self?.interactor.currentUserLogout { result in
                switch result {
                case.success(let bool):
                    print(bool)
                    Loader.shared.hideLoader()
                    if bool == true {
                        DispatchQueue.main.async { [weak self] in
                            self?.goToSignupVC()
                        }
                    }
                case.failure(let error):
                    print(error)
                    Loader.shared.hideLoader()
                    DispatchQueue.main.async { [weak self] in
                        self?.view?.errorAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func goToSignupVC(){
        router.goToSignupVC()
    }
    
    func goToEditProfileVC(){
        router.goToEditProfileVC()
    }
    
}
