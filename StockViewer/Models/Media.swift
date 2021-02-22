//
//  Media.swift
//  StockViewer
//
//  Created by Jim Long on 2/21/21.
//

import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String, filename: String = "\(arc4random()).jpeg") {
        self.key = key
        self.mimeType = "image/jpg"
        self.filename = filename
        
        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        self.data = data
    }
}
