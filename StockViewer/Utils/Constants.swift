//
//  Constants.swift
//  StockViewer
//
//  Created by Jim Long on 2/5/21.
//

import UIKit

struct Constants {
    
    enum LocalDiskSaverKeyName: String {
        case IsLoggedIn = "StockViewer.IsLoggedIn"
        case CreatingAccount = "StockViewer.CreatingAccount"
        case EnteringTrade = "StockViewer.EnteringTrade"
        case Email = "StockViewer.Email"
        case Password = "StockViewer.Password"
        case AccessToken = "StockViewer.AccessToken"
        case AccessTokenProperties = "StockViewer.AccessTokenProperties"
        case RefreshToken = "StockViewer.RefreshToken"
        case ImageCache = "StockViewer.ImageCache"
    }
    
    static let baseUrl = "https://api.jimlong.ca"
//    static let baseUrl = "http://192.168.7.168:3000"

    static let expiresIn5Minutes = TimeInterval(300) // 60 sec * 5

}
