//
//  ProfileVCInteractor.swift
//  Cinemax
//
//  Created by IPS-161 on 01/02/24.
//

import Foundation
import FirebaseAuth

protocol ProfileVCInteractorProtocol {
    func currentUserLogout(completion: @escaping (Result<Bool,Error>) -> ())
}

class ProfileVCInteractor {
    
}

extension ProfileVCInteractor: ProfileVCInteractorProtocol {
    
    func currentUserLogout(completion: @escaping (Result<Bool,Error>) -> ()) {
        if let currentUser = Auth.auth().currentUser {
            do {
                try Auth.auth().signOut()
                // Successful logout
                completion(.success(true))
            } catch let error as NSError {
                print("Error signing out: \(error.localizedDescription)")
                // Handle the error or log the user out even if there's an error (depending on your app's logic)
                completion(.failure(error))
            }
        }else{
            completion(.success(false))
        }
    }
    
}
