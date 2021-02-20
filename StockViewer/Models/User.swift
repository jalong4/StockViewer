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
    var profileImage: String?
    var date: String
    var email = String()
    var password = String()
}

class UserBody: Codable {
    var firstName = String()
    var lastName = String()
    var profileImage: String?
    var date = String()
    var email = String()
    var password = String()
    
    init (user: User) {
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.profileImage = user.profileImage
        self.date = user.date
        self.email = user.email
        self.password = user.password
    }
    
    init(firstName: String = String(),
         lastName: String = String(),
         profileImage: String? = nil,
         date: String = String(),
         email:String = String(),
         password: String = String()) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.profileImage = profileImage
        self.date = date
        self.email = email
        self.password = password
    }
}


struct LoginResponse: Codable {
    var response : Login
}

struct Login: Codable {
    var success: Bool
    var auth: Auth
}
