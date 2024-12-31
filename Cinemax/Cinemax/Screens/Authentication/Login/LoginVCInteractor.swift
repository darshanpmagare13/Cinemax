//
//  LoginVCInteractor.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import Foundation
import FirebaseAuth

protocol LoginVCInteractorProtocol {
    func signIn(email: String?, password: String?, completion: @escaping (Result<Bool,AuthenticationError>) -> Void)
    func fetchCurrentUserFromFirebase(completion: @escaping (Result<UserServerModel?, Error>) -> Void)
    func saveUsersDataToUserdefault(user:UserServerModel?)
}

class LoginVCInteractor {
    var userDataRepositoryManager : UserDataRepositoryManagerProtocol?
    init(userDataRepositoryManager : UserDataRepositoryManagerProtocol){
        self.userDataRepositoryManager = userDataRepositoryManager
    }
}

extension LoginVCInteractor: LoginVCInteractorProtocol {
    
    func signIn(email: String?, password: String?, completion: @escaping (Result<Bool,AuthenticationError>) -> Void){
        guard let email = email , let password = password else {
            return completion(.failure(AuthenticationError.invalidCredentials))
        }
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                // Handle sign-in error
                print("Sign-in error: \(error.localizedDescription)")
                completion(.failure(AuthenticationError.serverError(error)))
                return
            }
            print("Sign-in successful with email: \(email)")
            completion(.success(true))
        }
    }
    
    func fetchCurrentUserFromFirebase(completion: @escaping (Result<UserServerModel?, Error>) -> Void){
        FetchUserServerManager.shared.fetchCurrentUserFromFirebase { result in
            completion(result)
        }
    }
    
    func saveUsersDataToUserdefault(user:UserServerModel?){
        guard let user = user,
              let uid = user.uid,
              let firstName = user.firstName,
              let lastName = user.lastName,
              let phoneNumber = user.phoneNumber,
              let gender = user.gender,
              let dateOfBirth = user.dateOfBirth,
              let email = user.email,
              let profileImgUrl = user.profileImgUrl else {
            return
        }
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersUid, data: uid) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersFirstName, data: firstName) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersLastName, data: lastName) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersPhoneNumber, data: phoneNumber) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersGender, data: gender) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersDateOfBirth, data: dateOfBirth) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersEmail, data: email) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersProfileImageUrl, data: profileImgUrl) { _ in}
        userDataRepositoryManager?.userFirstName.onNext(firstName)
        userDataRepositoryManager?.userEmailAddress.onNext(email)
        userDataRepositoryManager?.userProfileImageUrl.onNext(profileImgUrl)
    }
    
}
