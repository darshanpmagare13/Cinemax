//
//  LoginVCPresenter.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol LoginVCPresenterProtocol {
    
    func viewDidload()
    func goToResetPasswordVC()
    func signIn(email: String?, password: String?)
    func goToMainTabVC()
    
    typealias Input = (
        email : Driver<String>,
        password : Driver<String>
    )
    
    typealias Output = (
        enableLogin : Driver<Bool>,()
    )
    
    typealias Producer = (LoginVCPresenterProtocol.Input) -> LoginVCPresenterProtocol
    
    var input : Input { get }
    var output : Output { get }
    
}

class LoginVCPresenter {
    weak var view: LoginVCProtocol?
    var interactor: LoginVCInteractorProtocol
    var router: LoginVCRouterProtocol
    var input:Input
    var output:Output
    init(view: LoginVCProtocol,interactor: LoginVCInteractorProtocol,router: LoginVCRouterProtocol,input:Input){
        self.view = view
        self.interactor = interactor
        self.router = router
        self.input = input
        self.output = LoginVCPresenter.output(input: input)
    }
}

extension LoginVCPresenter: LoginVCPresenterProtocol {
    func viewDidload(){
        DispatchQueue.main.async { [weak self] in
            self?.view?.setUpBinding()
            self?.view?.bindUI()
        }
    }
    
    func signIn(email: String?, password: String?){
        showLoader()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.interactor.signIn(email: email, password: password) { result in
                switch result {
                case.success(let bool):
                    print(bool)
                    self?.fetchCurrentUserFromFirebase{
                        DispatchQueue.main.async { [weak self] in
                            self?.hideLoader()
                            self?.goToMainTabVC()
                        }
                    }
                case.failure(let error):
                    switch error {
                    case .invalidCredentials:
                        print("Invalid credentials")
                        self?.hideLoader()
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
                            self?.view?.errorMsg(message: "Invalid credentials")
                        }
                    case .serverError(let serverError):
                        self?.hideLoader()
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
                            self?.view?.errorMsg(message: serverError.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    private func showLoader(){
        Loader.shared.showLoader(type: .lineScale, color: .white, background: LoaderVCBackground.withoutBlur)
    }
    
    private func hideLoader(){
        Loader.shared.hideLoader()
    }
    
    
    func goToResetPasswordVC(){
        router.goToResetPasswordVC()
    }
    
    func goToMainTabVC(){
        router.goToMainTabVC()
    }
    
    func fetchCurrentUserFromFirebase(completion:@escaping()->()){
        interactor.fetchCurrentUserFromFirebase { result in
            switch result{
            case.success(let user):
                self.interactor.saveUsersDataToUserdefault(user: user)
                completion()
            case.failure(let error):
                print(error)
                completion()
            }
        }
    }
    
}

private extension LoginVCPresenter {
    
    static func output(input:Input) -> Output {
        let enableLoginDriver =  Driver.combineLatest(input.email.map{( $0.isEmailValid())},
                                                      input.password.map{( !$0.isEmpty && $0.isPasswordValid())})
            .map{( $0 && $1 )}
        return (
            enableLogin : enableLoginDriver,()
        )
    }
    
}
