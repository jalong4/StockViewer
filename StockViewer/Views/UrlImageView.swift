//
//  UrlImageView.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI

struct UrlImageView: View {
    @EnvironmentObject var urlImageModel: UrlImageModel
    var defaultImageSystemName: String
    
    init(defaultImageSystemName: String) {
        self.defaultImageSystemName = defaultImageSystemName
    }
    

    
    var body: some View {
                        
        if let image = urlImageModel.image {
                return AnyView(Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 10, x: 0, y: 5))
        } else if urlImageModel.showDefault {
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
        UrlImageView(defaultImageSystemName: "person.circle")
            .environmentObject(UrlImageModel(urlString: "https://storage.googleapis.com/stock-service-bucket/b855b490-759a-11eb-ba6e-f9cc703eac4b_1401752256.jpeg"))
    }
}
