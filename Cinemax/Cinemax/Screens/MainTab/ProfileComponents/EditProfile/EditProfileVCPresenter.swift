//
//  EditProfileVCPresenter.swift
//  Cinemax
//
//  Created by IPS-161 on 02/02/24.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol EditProfileVCPresenterProtocol {
    func viewDidload()
    func saveCurrentUserImgToFirebaseStorageAndDatabase(image: UIImage)
    func updateCurrentuseerNameInDatabase(firstName:String?, lastName: String?, phoneNumber: String?, gender: String?, dateOfBirth: String?,completion:@escaping()->())
    typealias Input = (
        firstName : Driver<String>,
        lastName : Driver<String>,
        genderName : Driver<String>
    )
    typealias Output = (enableUpdate : Driver<Bool>,())
    typealias Producer = (EditProfileVCPresenterProtocol.Input) -> EditProfileVCPresenterProtocol
    var input : Input { get }
    var output : Output { get }
}

class EditProfileVCPresenter {
    weak var view: EditProfileVCProtocol?
    var interactor: EditProfileVCInteractorProtocol
    var input:Input
    var output:Output
    init(view: EditProfileVCProtocol,interactor: EditProfileVCInteractorProtocol,input:Input){
        self.view = view
        self.interactor = interactor
        self.input = input
        self.output = EditProfileVCPresenter.output(input: input)
    }
}

extension EditProfileVCPresenter: EditProfileVCPresenterProtocol {
    
    func viewDidload(){
        DispatchQueue.main.async { [weak self] in
            self?.view?.setUpBinding()
        }
    }
    
    func saveCurrentUserImgToFirebaseStorageAndDatabase(image: UIImage){
        DispatchQueue.main.async { [weak self] in
            Loader.shared.showLoader(type: .lineScale, color: .white, background: LoaderVCBackground.withoutBlur)
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.interactor.saveCurrentUserImgToFirebaseStorageAndDatabase(image: image) { result in
                switch result{
                case.success(let bool):
                    print(bool)
                    DispatchQueue.main.async { [weak self] in
                        Loader.shared.hideLoader()
                    }
                case.failure(let error):
                    print(error)
                    DispatchQueue.main.async { [weak self] in
                        Loader.shared.hideLoader()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){  [weak self] in
                        self?.view?.errorMsgAlert(error: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func updateCurrentuseerNameInDatabase(firstName:String?, lastName: String?, phoneNumber: String?, gender: String?, dateOfBirth: String?,completion:@escaping()->()){
        DispatchQueue.main.async { [weak self] in
            Loader.shared.showLoader(type: .lineScale, color: .white, background: LoaderVCBackground.withoutBlur)
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.interactor.updateCurrentuseerNameInDatabase(firstName: firstName ?? "", lastName: lastName ?? "", phoneNumber: phoneNumber ?? "", gender: gender ?? "", dateOfBirth: dateOfBirth ?? "") { result in
                switch result{
                case .success(let bool):
                    print(bool)
                    self?.interactor.updateCurrentUsernameInUserdefault(firstName: firstName ?? "", lastName: lastName ?? "", phoneNumber: phoneNumber ?? "", gender: gender ?? "", dateOfBirth: dateOfBirth ?? "")
                    DispatchQueue.main.async { [weak self] in
                        Loader.shared.hideLoader()
                        completion()
                    }
                case.failure(let error):
                    print(error)
                    DispatchQueue.main.async { [weak self] in
                        Loader.shared.hideLoader()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){  [weak self] in
                        self?.view?.errorMsgAlert(error: error.localizedDescription)
                    }
                }
            }
        }
    }
    
}

private extension EditProfileVCPresenter {
    
    static func output(input:Input) -> Output {
        let enableUpdateDriver =  Driver.combineLatest(input.firstName.map{($0.isValidName())},
                                                       input.lastName.map{($0.isValidName())},
                                                       input.genderName.map{(!$0.isEmpty)})
            .map{($0 && $1 && $2)}
        return (enableUpdate:enableUpdateDriver,())
    }
    
}
