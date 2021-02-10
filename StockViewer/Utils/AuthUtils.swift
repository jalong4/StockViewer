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
        else { return }
        
        if accessTokenProperties.exp > (Date().timeIntervalSince1970 + Constants.expiresIn5Minutes) {
            SettingsManager.sharedInstance.isLoggedIn = true
            return;
        }
        
        SettingsManager.sharedInstance.accessToken = nil
        SettingsManager.sharedInstance.accessTokenProperties = nil

        
        SettingsManager.sharedInstance.isLoggedIn = false;
        NotificationCenter.default.post(name: NSNotification.Name("AuthStatusChange"), object: nil)
        
        // Add code here to refresh token, for now make user re-login
        
    }
    
    public func logOut() {
        SettingsManager.sharedInstance.accessToken = nil
        SettingsManager.sharedInstance.accessTokenProperties = nil
        SettingsManager.sharedInstance.refreshToken = nil
        SettingsManager.sharedInstance.isLoggedIn = false;
        NotificationCenter.default.post(name: NSNotification.Name("AuthStatusChange"), object: nil)
    }
    
    public func handleLogin(email: String, password: String) {
        
        SettingsManager.sharedInstance.email = email
        SettingsManager.sharedInstance.password = password
        self.logOut()
        
        Api().login(email: email, password: password, completion: { loginResponse in
            let iat = Date(timeIntervalSince1970: loginResponse.response.auth.accessTokenProperties.iat);
            let exp = Date(timeIntervalSince1970: loginResponse.response.auth.accessTokenProperties.exp);
            print("AccessToken: \(loginResponse.response.auth.accessToken)")
            print("RefreshToken : \(loginResponse.response.auth.refreshToken)")
            print("Token: iat: \(iat)")
            print("Token: exp: \(exp)")
            SettingsManager.sharedInstance.accessToken = loginResponse.response.auth.accessToken
            SettingsManager.sharedInstance.refreshToken = loginResponse.response.auth.refreshToken
            
            guard
                let accessTokenPropertiesData = try? JSONEncoder().encode(loginResponse.response.auth.accessTokenProperties),
                let accessTokenPropertiesString = String(data: accessTokenPropertiesData, encoding: .utf8)
            else { return }
            
            SettingsManager.sharedInstance.accessTokenProperties = accessTokenPropertiesString
            SettingsManager.sharedInstance.isLoggedIn = true;
            NotificationCenter.default.post(name: NSNotification.Name("AuthStatusChange"), object: nil)
        })
        
    }
}
