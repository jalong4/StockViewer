//
//  AuthUtils.swift
//  StockViewer
//
//  Created by Jim Long on 2/9/21.
//

import Foundation
import SwiftUI

class AuthUtils: ObservableObject {
    
    public func checkAuthToken() {
        guard let _ = SettingsManager.sharedInstance.accessToken,
              let accessTokenPropertiesData = SettingsManager.sharedInstance.accessTokenProperties?.data(using: .utf8),
              let accessTokenProperties = try? JSONDecoder().decode(AccessTokenProperties.self, from: accessTokenPropertiesData)
        else {
            SettingsManager.sharedInstance.isLoggedIn = false
            return
        }
        
        if accessTokenProperties.exp > (Date().timeIntervalSince1970 + Constants.expiresIn5Minutes) {
            SettingsManager.sharedInstance.isLoggedIn = true
            return;
        }
        
        SettingsManager.sharedInstance.accessToken = nil
        SettingsManager.sharedInstance.accessTokenProperties = nil

        
        SettingsManager.sharedInstance.isLoggedIn = false
        
        // Add code here to refresh token, for now make user re-login
        
    }
    
    public func logOut() {
        SettingsManager.sharedInstance.accessToken = nil
        SettingsManager.sharedInstance.accessTokenProperties = nil
        SettingsManager.sharedInstance.refreshToken = nil
        SettingsManager.sharedInstance.isLoggedIn = false;
    }
    
}
