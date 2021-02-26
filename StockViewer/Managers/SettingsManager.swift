//
//  SettingsManager.swift
//  StockViewer
//
//  Created by Jim Long on 2/5/21.
//

import UIKit

class SettingsManager {
    
    static let sharedInstance = SettingsManager()
    
    var isLoggedIn: Bool? {
        get {    return LocalDiskSaver.get(key: .IsLoggedIn, isSecure: false) as? Bool }
        set (newValue) { LocalDiskSaver.set(key: .IsLoggedIn, isSecure: false, newValue: newValue as AnyObject?) }
    }

    var creatingAccount: Bool? {
        get {    return LocalDiskSaver.get(key: .CreatingAccount, isSecure: false) as? Bool }
        set (newValue) { LocalDiskSaver.set(key: .CreatingAccount, isSecure: false, newValue: newValue as AnyObject?) }
    }
    
    var enteringTrade: Bool? {
        get {    return LocalDiskSaver.get(key: .EnteringTrade, isSecure: false) as? Bool }
        set (newValue) { LocalDiskSaver.set(key: .EnteringTrade, isSecure: false, newValue: newValue as AnyObject?) }
    }
    
    var email: String? {
        get {    return LocalDiskSaver.get(key: .Email, isSecure: true) as? String }
        set (newValue) { LocalDiskSaver.set(key: .Email, isSecure: true, newValue: newValue as AnyObject?) }
    }
    
    var password: String? {
        get {    return LocalDiskSaver.get(key: .Password, isSecure: true) as? String }
        set (newValue) { LocalDiskSaver.set(key: .Password, isSecure: true, newValue: newValue as AnyObject?) }
    }
    
    var profileImageUrl: String? {
        get {    return LocalDiskSaver.get(key: .ProfileImageUrl, isSecure: false) as? String }
        set (newValue) { LocalDiskSaver.set(key: .ProfileImageUrl, isSecure: false, newValue: newValue as AnyObject?) }
    }
    
    var accessToken: String? {
        get {    return LocalDiskSaver.get(key: .AccessToken, isSecure: true) as? String }
        set (newValue) { LocalDiskSaver.set(key: .AccessToken, isSecure: true, newValue: newValue as AnyObject?) }
    }
    
    var refreshToken: String? {
        get {    return LocalDiskSaver.get(key: .RefreshToken, isSecure: true) as? String }
        set (newValue) { LocalDiskSaver.set(key: .RefreshToken, isSecure: true, newValue: newValue as AnyObject?) }
    }
    
    var accessTokenProperties: String? {
        get {    return LocalDiskSaver.get(key: .AccessTokenProperties, isSecure: true) as? String }
        set (newValue) { LocalDiskSaver.set(key: .AccessTokenProperties, isSecure: true, newValue: newValue as AnyObject?) }
    }
    
    var imageCache: [String : UIImage]? {
        get {    return LocalDiskSaver.get(key: .ImageCache, isSecure: false) as? [String : UIImage] }
        set (newValue) { LocalDiskSaver.set(key: .ImageCache, isSecure: false, newValue: newValue as AnyObject?) }
    }

}
