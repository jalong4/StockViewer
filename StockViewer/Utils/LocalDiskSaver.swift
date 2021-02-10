//
//  LocalDiskSaver.swift
//  StockViewer
//
//  Created by Jim Long on 2/5/21.
//

import KeychainSwift

class LocalDiskSaver {
    
    fileprivate static var cache = [String: Any]()
    fileprivate static let keychain = KeychainSwift()
    
    class func get(key: Constants.LocalDiskSaverKeyName, isSecure: Bool) -> Any? {
        
        if let cachedValue = cache[key.rawValue] {
            return cachedValue
        }
        
        if let
            archivedValue = isSecure ? keychain.getData(key.rawValue) : UserDefaults.standard.value(forKey: key.rawValue) as? Data,
           let valueFromDisk = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedValue) as Any? {
            
            cache[key.rawValue] = valueFromDisk
            return valueFromDisk
        }
        return nil
    }
    
    class func set(key: Constants.LocalDiskSaverKeyName, isSecure: Bool, newValue: Any?) {
        
        if let newValue = newValue {
                        
            let newArchivedValue = try! NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
            
            if isSecure {
                if keychain.set(newArchivedValue, forKey: key.rawValue) == false {
                    print("Could not save keychain data for \(key.rawValue)")
                }
            } else {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(newArchivedValue, forKey: key.rawValue)
                }
            }
        }
        else { // newValue is nil, delete saved value
            
            if isSecure {
                if keychain.delete(key.rawValue) == false {
                    print("Could not delete keychain data for \(key.rawValue)")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            }
        }
        
        cache[key.rawValue] = newValue
    }
}
