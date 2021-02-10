//
//  Auth.swift
//  StockViewer
//
//  Created by Jim Long on 2/8/21.
//

import SwiftUI

struct Auth: Codable {
    var accessToken = String()
    var refreshToken = String()
    var accessTokenProperties = AccessTokenProperties()
}

struct AccessTokenProperties: Codable {
    var email = String()
    var iat: Double = 0.0
    var exp: Double = 0.0
}

