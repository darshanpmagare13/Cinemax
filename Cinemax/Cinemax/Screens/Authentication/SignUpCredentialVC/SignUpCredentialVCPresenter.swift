//
//  SignUpCredentialVCPresenter.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseAuth

protocol SignUpCredentialVCPresenterProtocol {
    
    func viewDidload()
    func signUp(firstName: String?, lastName: String?, phoneNumber: String?, gender: String?, dateOfBirth: String?,email: String?, password: String?)
    func goToMainTabVC()
    
    typealias Input = (
        email : Driver<String>,
        password : Driver<String>,
        firstName : Driver<String>,
        lastName : Driver<String>,
        genderName : Driver<String>,
        isTermsAndConditionAccept : Driver<Bool>
    )
    
    typealias Output = (enableLogin : Driver<Bool>,())
    typealias Producer = (SignUpCredentialVCPresenterProtocol.Input) -> SignUpCredentialVCPresenterProtocol
    
    var input : Input { get }
    var output : Output { get }
}

class SignUpCredentialVCPresenter {
    weak var view: SignUpCredentialVCProtocol?
    var interactor: SignUpCredentialVCInteractorProtocol
    var router: SignUpCredentialVCRouterProtocol
    var input:Input
    var output:Output
    init(view: SignUpCredentialVCProtocol,interactor: SignUpCredentialVCInteractorProtocol,router: SignUpCredentialVCRouterProtocol,input:Input){
        self.view = view
        self.interactor = interactor
        self.router = router
        self.input = input
        self.output = SignUpCredentialVCPresenter.output(input: input)
    }
}

extension SignUpCredentialVCPresenter: SignUpCredentialVCPresenterProtocol {
    
    func viewDidload(){
        DispatchQueue.main.async { [weak self] in
            self?.view?.setUpBinding()
        }
    }
    
    func signUp(firstName: String?, lastName: String?, phoneNumber: String?, gender: String?, dateOfBirth: String?,email: String?, password: String?){
        showLoader()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.interactor.signUp(email: email, password: password) { result in
                switch result {
                case.success(let bool):
                    print(bool)
                    self?.interactor.saveUsersDataToUserdefault(firstName: firstName ?? "", lastName: lastName ?? "", phoneNumber: phoneNumber ?? "", gender: gender ?? "", dateOfBirth: dateOfBirth ?? "", email: email ?? "")
                    self?.saveUserDataToServer(firstName: firstName ?? "", lastName: lastName ?? "", phoneNumber: phoneNumber ?? "", gender: gender ?? "", dateOfBirth: dateOfBirth ?? "", email: email ?? "", completion: {
                        self?.hideLoader()
                        DispatchQueue.main.async { [weak self] in
                            self?.view?.successMsg(message: "Signup successfully, you can login in Login section.")
                        }
                    })
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
    
    func goToMainTabVC(){
        router.goToMainTabVC()
    }
    
    func saveUserDataToServer(firstName: String, lastName: String, phoneNumber:String, gender: String, dateOfBirth:String, email: String,completion:@escaping()->()){
        interactor.saveUserDataToServer(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, gender: gender, dateOfBirth: dateOfBirth, email: email) { result in
            switch result {
            case.success(let bool):
                print(bool)
                completion()
            case.failure(let error):
                print(error)
                completion()
            }
        }
    }
    
}

private extension SignUpCredentialVCPresenter {
    
    static func output(input:Input) -> Output {
        let enableLoginDriver =  Driver.combineLatest(input.email.map{( $0.isEmailValid())},
                                                      input.password.map{( !$0.isEmpty && $0.isPasswordValid())},
                                                      input.firstName.map{($0.isValidName())},
                                                      input.lastName.map{($0.isValidName())},
                                                      input.genderName.map{(!$0.isEmpty)},
                                                      input.isTermsAndConditionAccept.map{(
                                                        ($0 == true) ? true : false )}
        ).map{( $0 && $1 && $2 && $3 && $4 && $5 )}
        return (enableLogin:enableLoginDriver,())
    }
    
}
