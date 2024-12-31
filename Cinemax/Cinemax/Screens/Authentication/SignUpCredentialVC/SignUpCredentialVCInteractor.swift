//
//  SignUpCredentialVCInteractor.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import Foundation
import FirebaseAuth

enum AuthenticationError : Error {
    case invalidCredentials
    case serverError(Error)
}


protocol SignUpCredentialVCInteractorProtocol {
    func signUp(email: String?, password: String?, completion: @escaping (Result<Bool,AuthenticationError>) -> Void)
    func saveUserDataToServer(firstName: String?, lastName: String?, phoneNumber: String?, gender: String?, dateOfBirth: String?, email: String?,completion: @escaping EscapingResultBoolErrorClosure)
    func saveUsersDataToUserdefault(firstName: String?, lastName: String?, phoneNumber: String?, gender: String?, dateOfBirth: String?, email: String?)
}

class SignUpCredentialVCInteractor {
    var userDataRepositoryManager : UserDataRepositoryManagerProtocol?
    init(userDataRepositoryManager : UserDataRepositoryManagerProtocol){
        self.userDataRepositoryManager = userDataRepositoryManager
    }
}

extension SignUpCredentialVCInteractor: SignUpCredentialVCInteractorProtocol {
    
    func signUp(email: String?, password: String?, completion: @escaping (Result<Bool,AuthenticationError>) -> Void){
        guard let email = email , let password = password else {
            return completion(.failure(AuthenticationError.invalidCredentials))
        }
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                // Handle sign-up error
                print("Sign-up error: \(error.localizedDescription)")
                completion(.failure(AuthenticationError.serverError(error)))
                return
            }
            print("Sign-up successful with email: \(email)")
            completion(.success(true))
        }
    }
    
    func saveUserDataToServer(firstName: String?, lastName: String?, phoneNumber: String?, gender: String?, dateOfBirth: String?, email: String?,completion: @escaping EscapingResultBoolErrorClosure){
        StoreUserServerManager.shared.storeCurrentUserDataToServerNameAndEmail(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, gender: gender, dateOfBirth: dateOfBirth, email: email){ data in
            completion(data)
        }
    }
    
    func saveUsersDataToUserdefault(firstName: String?, lastName: String?, phoneNumber: String?, gender: String?, dateOfBirth: String?, email: String?){
        guard let firstName = firstName,
              let lastName = lastName,
              let phoneNumber = phoneNumber,
              let gender = gender,
              let email = email,
              let dateOfBirth = dateOfBirth,
              let currentUid = Auth.auth().currentUser?.uid else {
            return
        }
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersFirstName, data: firstName) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersLastName, data: lastName) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersPhoneNumber, data: phoneNumber) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersGender, data: gender) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersDateOfBirth, data: dateOfBirth) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersEmail, data: email) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersUid, data: currentUid) { _ in}
        userDataRepositoryManager?.userFirstName.onNext(firstName)
        userDataRepositoryManager?.userEmailAddress.onNext(email)
    }
    
}
