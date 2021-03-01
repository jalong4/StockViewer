//
//  UrlImageModel.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import Foundation
import SwiftUI

class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    
    private var urlString: String?
    var imageCache = ImageCache()
    var showDefault = false
    

    
    init(urlString: String?) {
        print("UrlImageModel.urlString: " + (urlString ?? "nil"))
        self.urlString = urlString
        loadImage()
    }
    
    
    private func loadImage() {
        guard
            let urlString = self.urlString
        else {
            showDefault = true
            return
        }
        
        if loadImageFromCache(urlString: urlString) {
            print("Cache hit")
            return
        }
        
        print("Cache miss, loading from url")
        loadImageFromUrl(urlString: urlString)
    }
    
    private func loadImageFromCache(urlString: String) -> Bool {
        guard
            let cacheImage = imageCache.get(key: urlString) else {
            return false
        }
        
        DispatchQueue.main.async {
            self.image = cacheImage
        }
        return true
    }
    
    private func loadImageFromUrl(urlString: String) {
        guard
            let url = URL(string: urlString)
        else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard error == nil else {
                print("Error: \(error!)")
                return
            }
            guard let data = data else {
                print("No data found")
                return
            }
            
            guard let urlString = self.urlString else {
                print("Url not set")
                return
            }
            
            DispatchQueue.main.async {
                guard
                    let loadedImage = UIImage(data: data)
                else {
                    return
                }
                
                self.imageCache.set(key: urlString, image: loadedImage)
                self.image = loadedImage
            }
        }
        task.resume()
    }
}

