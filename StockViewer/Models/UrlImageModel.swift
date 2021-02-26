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
    
    @Binding private var urlString: String?
    var imageCache = ImageCache()
    
    init(urlString: Binding<String?>) {
        self._urlString = urlString
    }
    
    func loadImage() {
        if loadImageFromCache() {
            print("Cache hit")
            return
        }
        
        print("Cache miss, loading from url")
        loadImageFromUrl()
    }
    
    func loadImageFromCache() -> Bool {
        guard
            let urlString = self.urlString,
            let cacheImage = imageCache.get(key: urlString) else {
            return false
        }
        
        image = cacheImage
        return true
    }
    
    func loadImageFromUrl() {
        guard
            let urlString = self.urlString,
            let url = URL(string: urlString)
        else { return }

        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
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
}

