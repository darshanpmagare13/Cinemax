//
//  ResetPasswordVCPresenter.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol ResetPasswordVCPresenterProtocol {
    func viewDidload()
    func resetPasswordRequest(email: String?)
    
    typealias Input = (
        email : Driver<String>,()
    )
    
    typealias Output = (
        enableReset : Driver<Bool>,()
    )
    
    typealias Producer = (ResetPasswordVCPresenterProtocol.Input) -> ResetPasswordVCPresenterProtocol
    
    var input : Input { get }
    var output : Output { get }
    
}

class ResetPasswordVCPresenter {
    weak var view: ResetPasswordVCPrtocol?
    var interactor: ResetPasswordVCInteractorProtocol
    var input:Input
    var output:Output
    init(view: ResetPasswordVCPrtocol,interactor: ResetPasswordVCInteractorProtocol,input:Input){
        self.view = view
        self.interactor = interactor
        self.input = input
        self.output = ResetPasswordVCPresenter.output(input: input)
    }
}

extension ResetPasswordVCPresenter: ResetPasswordVCPresenterProtocol {
    
    func viewDidload(){
        DispatchQueue.main.async { [weak self] in
            self?.view?.setUpBinding()
        }
    }
    
    func resetPasswordRequest(email: String?){
        showLoader()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.interactor.resetPasswordRequest(email: email) { result in
                switch result {
                case.success(let bool):
                    print(bool)
                    self?.hideLoader()
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
                        self?.view?.successAlert(message: "Password reset link send to your email successfully, Kindly check your mailbox.")
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
    
}

private extension ResetPasswordVCPresenter {
    
    static func output(input:Input) -> Output {
        let enableResetDriver =  input.email.map { $0.isEmailValid() }
        return (
            enableReset : enableResetDriver,()
        )
    }
    
}
