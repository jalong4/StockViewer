//
//  User.swift
//  StockViewer
//
//  Created by Jim Long on 2/8/21.
//

import SwiftUI

struct User: Codable {
    var _id = String()
    var firstName = String()
    var lastName = String()
    var profileImageUrl: String?
    var date: String
    var email = String()
    var password = String()
}

class UserBody: Codable {
    var firstName = String()
    var lastName = String()
    var profileImageUrl: String?
    var date = String()
    var email = String()
    var password = String()
    
    init (user: User) {
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.profileImageUrl = user.profileImageUrl
        self.date = user.date
        self.email = user.email
        self.password = user.password
    }
    
    init(firstName: String = String(),
         lastName: String = String(),
         profileImageUrl: String? = nil,
         date: String = String(),
         email:String = String(),
         password: String = String()) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageUrl = profileImageUrl
        self.date = date
        self.email = email
        self.password = password
    }
}


struct LoginResponse: Codable {
    var response : Login
}

struct RegistrationResponse: Codable {
    var response : Register
}

struct Register: Codable {
    var error: String?
    var user: User?
    var auth: Auth?
}

struct ChangePasswordResponse: Codable {
    var response : ChangePassword
}

struct ChangePassword: Codable {
    var message: String?
    var success: Bool
    var user: User
}

struct Login: Codable {
    var success: Bool
    var user: User?
    var auth: Auth?
}

struct UploadImageResponse: Codable {
    var message: String?
    var profileImageUrl: String?
}
