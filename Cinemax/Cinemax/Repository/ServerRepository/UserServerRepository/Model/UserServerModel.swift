//
//  UserServerModel.swift
//  Cinemax
//
//  Created by IPS-161 on 01/02/24.
//

import Foundation

struct UserServerModel {
    var uid:String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var gender: String?
    var dateOfBirth: String?
    var email: String?
    var profileImgUrl: String?
    init(uid:String,
         firstName:String,
         lastName:String,
         phoneNumber:String,
         gender:String,
         dateOfBirth:String,
         email:String,
         profileImgUrl:String){
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        self.email = email
        self.profileImgUrl = profileImgUrl
    }
}
