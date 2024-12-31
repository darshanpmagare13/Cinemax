//
//  ResetPasswordVCInteractor.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import Foundation
import FirebaseAuth

protocol ResetPasswordVCInteractorProtocol {
    func resetPasswordRequest(email: String?,completion: @escaping (Result<Bool,AuthenticationError>) -> Void)
}

class ResetPasswordVCInteractor {
    
}

extension ResetPasswordVCInteractor: ResetPasswordVCInteractorProtocol {
    
    func resetPasswordRequest(email: String?,completion: @escaping (Result<Bool,AuthenticationError>) -> Void){
        guard let email = email  else {
            return completion(.failure(AuthenticationError.invalidCredentials))
        }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                // An error occurred while sending the password reset email
                print("Error: \(error.localizedDescription)")
                completion(.failure(AuthenticationError.serverError(error)))
            } else {
                // Password reset email sent successfully
                print("Password reset email sent successfully")
                completion(.success(true))
            }
        }
    }
    
}

