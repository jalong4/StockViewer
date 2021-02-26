//
//  ImageCache.swift
//  StockViewer
//
//  Created by Jim Long on 2/22/21.
//

import UIKit

class ImageCache {
    
    func get(key: String) -> UIImage? {
        guard let cache = SettingsManager.sharedInstance.imageCache else { return nil }
        return cache[key]
    }
    
    func set(key: String, image: UIImage) {
        if SettingsManager.sharedInstance.imageCache == nil {
            SettingsManager.sharedInstance.imageCache = [String: UIImage]()
        } else {
            SettingsManager.sharedInstance.imageCache![key] = image
        }
    }
    
}
