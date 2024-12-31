//
//  UserDataRepositoryManager.swift
//  Cinemax
//
//  Created by IPS-177  on 15/04/24.
//

import Foundation
import RxSwift
import UIKit

protocol UserDataRepositoryManagerProtocol {
    var userFirstName: BehaviorSubject<String> { get set }
    var userLastName: BehaviorSubject<String> { get set }
    var userPhoneNumber: BehaviorSubject<String> { get set }
    var userDateOfBirth: BehaviorSubject<String> { get set }
    var userGender: BehaviorSubject<String> { get set }
    var userProfileImageUrl: BehaviorSubject<String> { get set }
    var userEmailAddress: BehaviorSubject<String> { get set }
}

class UserDataRepositoryManager {
    static let shared = UserDataRepositoryManager()
    var userFirstName = BehaviorSubject(value:"")
    var userLastName = BehaviorSubject(value:"")
    var userPhoneNumber = BehaviorSubject(value:"")
    var userDateOfBirth = BehaviorSubject(value:"")
    var userGender = BehaviorSubject(value:"")
    var userProfileImageUrl = BehaviorSubject(value:"")
    var userEmailAddress = BehaviorSubject(value:"")
    init(){
        updateUserData()
    }
}

extension UserDataRepositoryManager: UserDataRepositoryManagerProtocol {
    func updateUserData(){
        if let userFirstName = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersFirstName){
            self.userFirstName.onNext(userFirstName)
        }
        if let userLastName = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersLastName){
            self.userLastName.onNext(userLastName)
        }
        if let userPhoneNumber = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersPhoneNumber){
            self.userPhoneNumber.onNext(userPhoneNumber)
        }
        if let userDateOfBirth = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersDateOfBirth){
            self.userDateOfBirth.onNext(userDateOfBirth)
        }
        if let userGender = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersGender){
            self.userGender.onNext(userGender)
        }
        if let userProfileImageUrl = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersProfileImageUrl){
            self.userProfileImageUrl.onNext(userProfileImageUrl)
        }
        if let userEmailAddress = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersEmail){
            self.userEmailAddress.onNext(userEmailAddress)
        }
    }
}
