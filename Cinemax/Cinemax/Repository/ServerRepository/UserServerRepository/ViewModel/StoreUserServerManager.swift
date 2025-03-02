//
//  StoreUserServerManager.swift
//  Cinemax
//
//  Created by IPS-161 on 01/02/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit
import Cloudinary


typealias EscapingResultBoolErrorClosure = (Result<Bool, Error>)->()

public final class StoreUserServerManager {
    static let shared = StoreUserServerManager()
    let cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "dnacxvjs5", secure: true))
    private init(){}
    
    // MARK: - Store Current UserName And Email To Server
    
    func storeCurrentUserDataToServerNameAndEmail(firstName: String?,
                                                  lastName: String?,
                                                  phoneNumber: String?,
                                                  gender: String?,
                                                  dateOfBirth: String?,
                                                  email: String?,
                                                  completion: @escaping EscapingResultBoolErrorClosure) {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let firstName = firstName,
              let lastName = lastName,
              let phoneNumber = phoneNumber,
              let gender = gender,
              let dateOfBirth = dateOfBirth,
              let email = email else {
            completion(.failure(NSError(domain: "CINEMAX", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserId)
        // Create a dictionary with both the uid and fcmToken
        let data: [String: Any] = ["uid": currentUserId,
                                   "firstName": firstName,
                                   "lastName": lastName,
                                   "phoneNumber": phoneNumber,
                                   "gender": gender,
                                   "dateOfBirth": dateOfBirth,
                                   "email": email]
        // Set the document with the combined data
        userRef.setData(data, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    // MARK: - Update Current UserName In Database
    
    func updateCurrentUserNameInDatabase(firstName: String?,
                                         lastName: String?,
                                         phoneNumber: String?,
                                         gender: String?,
                                         dateOfBirth: String?,
                                         completion: @escaping EscapingResultBoolErrorClosure){
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let firstName = firstName,
              let lastName = lastName,
              let phoneNumber = phoneNumber,
              let gender = gender,
              let dateOfBirth = dateOfBirth else {
            completion(.failure(NSError(domain: "CINEMAX", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in or invalid name"])))
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserId)
        
        // Create a dictionary with the updated name
        let data: [String: Any] = ["firstName": firstName,
                                   "lastName": lastName,
                                   "phoneNumber": phoneNumber,
                                   "gender": gender,
                                   "dateOfBirth": dateOfBirth]
        
        // Set the document with the updated data
        userRef.setData(data, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }


    // MARK: - Save Current User Image To FirebaseStorage (Cloudinary)
    func saveCurrentUserImageToFirebaseStorage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }

        let config = CLDConfiguration(cloudName: "dnacxvjs5", secure: true)
        let cloudinary = CLDCloudinary(configuration: config)
        
        let uploader = cloudinary.createUploader()
        
        uploader.upload(data: imageData, uploadPreset: "Profile_Images") { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let result = result, let secureUrlString = result.secureUrl, let secureUrl = URL(string: secureUrlString) {
                completion(.success(secureUrl))
                print("Uploaded Image URL: \(secureUrl)")
            } else {
                completion(.failure(NSError(domain: "UploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown upload error"])))
            }
        }
    }
    
    // MARK: - Save Current User Image To FirebaseDatabase
    
    func saveCurrentUserImageToFirebaseDatabase(url: String?, completion:@escaping(Result<Bool,Error>)->()){
        guard let profileImgUrl = url else {
            completion(.failure(NSError(domain: "CINEMAX", code: 0, userInfo: [NSLocalizedDescriptionKey: "Url error."])))
            return
        }
        let db = Firestore.firestore()
        if let currentUserId = Auth.auth().currentUser?.uid{
            let userRef = db.collection("users").document(currentUserId)
            // Create a dictionary with both the uid and fcmToken
            let data: [String: Any] = ["profileImgUrl": profileImgUrl]
            // Set the document with the combined data
            userRef.setData(data, merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
        }
    }
    
}
