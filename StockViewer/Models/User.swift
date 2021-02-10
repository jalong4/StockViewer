//
//  User.swift
//  StockViewer
//
//  Created by Jim Long on 2/8/21.
//

import SwiftUI

struct User: Codable {
    var email = String()
    var password = String()
}


struct LoginResponse: Codable {
    var response : Login
}

struct Login: Codable {
    var success: Bool
    var auth: Auth
}
