//
//  UrlImageView.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI

struct UrlImageView: View {
    @Binding var urlImageModel: UrlImageModel?
    @Binding var showDefault: Bool
    
    var defaultImageSystemName: String
    
    func setShowDefault(_ showDefault: Bool) {
        self.showDefault = showDefault
    }
    
    func loadImage() {
        urlImageModel?.loadImage()
    }

    
    var body: some View {
        
        if let image = urlImageModel?.image {
                return AnyView(Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 10, x: 0, y: 5))
        } else if showDefault {
                return AnyView(Image(systemName: defaultImageSystemName)
                                .font(.system(size: 100, weight: .thin))
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 10))
        } else {
            return AnyView(Image(systemName: defaultImageSystemName)
                            .frame(width: 100, height: 100)
                            .hidden()
                            .disabled(true))
        }
    }
    
}

struct UrlImageView_Previews: PreviewProvider {
    static var previews: some View {
        UrlImageView(urlImageModel: .constant(UrlImageModel(urlString: .constant(nil))), showDefault: .constant(true), defaultImageSystemName: "person.circle")
    }
}
