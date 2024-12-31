//
//  EditProfileVCInteractor.swift
//  Cinemax
//
//  Created by IPS-161 on 02/02/24.
//

import Foundation
import UIKit

protocol EditProfileVCInteractorProtocol {
    func saveCurrentUserImgToFirebaseStorageAndDatabase(image: UIImage,completion:@escaping(Result<Bool,Error>)->())
    func updateCurrentuseerNameInDatabase(firstName:String?, lastName: String?, phoneNumber: String?, gender: String?, dateOfBirth: String?,completion: @escaping EscapingResultBoolErrorClosure)
    func updateCurrentUsernameInUserdefault(firstName:String, lastName: String, phoneNumber: String, gender: String, dateOfBirth: String)
}

class EditProfileVCInteractor {
    var userDataRepositoryManager: UserDataRepositoryManagerProtocol?
    init(userDataRepositoryManager: UserDataRepositoryManagerProtocol){
        self.userDataRepositoryManager = userDataRepositoryManager
    }
}

extension EditProfileVCInteractor: EditProfileVCInteractorProtocol {
    
    func saveCurrentUserImgToFirebaseStorageAndDatabase(image: UIImage,completion:@escaping(Result<Bool,Error>)->()){
        StoreUserServerManager.shared.saveCurrentUserImageToFirebaseStorage(image: image) { result in
            switch result {
            case.success(let url):
                let profileUrl = url.absoluteString
                self.saveImgUrlToDatabase(url: profileUrl){ urlData in
                    switch urlData {
                    case.success(let bool):
                        completion(.success(bool))
                        self.saveCurrentUserImageUrlToUserDefault(url:profileUrl)
                    case.failure(let error):
                        completion(.failure(error))
                    }
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    
    private func saveImgUrlToDatabase(url:String,completion:@escaping(Result<Bool,Error>)->()){
        StoreUserServerManager.shared.saveCurrentUserImageToFirebaseDatabase(url: url) { result in
            completion(result)
        }
    }
    
    private func saveCurrentUserImageUrlToUserDefault(url:String?){
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersProfileImageUrl, data: url) { _ in}
        if let url = url {
            userDataRepositoryManager?.userProfileImageUrl.onNext(url)
        }
    }
    
    func updateCurrentuseerNameInDatabase(firstName:String?, lastName: String?, phoneNumber: String?, gender: String?, dateOfBirth: String?,completion: @escaping EscapingResultBoolErrorClosure){
        StoreUserServerManager.shared.updateCurrentUserNameInDatabase(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, gender: gender, dateOfBirth: dateOfBirth){ result in
            completion(result)
        }
    }
    
    func updateCurrentUsernameInUserdefault(firstName:String, lastName: String, phoneNumber: String, gender: String, dateOfBirth: String){
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersFirstName, data: firstName) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersLastName, data: lastName) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersPhoneNumber, data: phoneNumber) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersGender, data: gender) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersDateOfBirth, data: dateOfBirth) { _ in}
        userDataRepositoryManager?.userFirstName.onNext(firstName)
        userDataRepositoryManager?.userLastName.onNext(lastName)
        userDataRepositoryManager?.userPhoneNumber.onNext(phoneNumber)
        userDataRepositoryManager?.userGender.onNext(gender)
        userDataRepositoryManager?.userDateOfBirth.onNext(dateOfBirth)
    }
    
}
