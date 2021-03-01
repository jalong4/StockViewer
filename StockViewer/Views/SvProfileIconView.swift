//
//  SvProfileIconView.swift
//  StockViewer
//
//  Created by Jim Long on 2/27/21.
//

import SwiftUI

//  Sv prefix signifies standardized for Stock Viewer design architecture

struct SvProfileIconView: View {

    @Binding var profileImageUrl: String?
    private let sfSymbolName: String
    private let viewOnly: Bool

    @State private var isShowPhotoLibrary = false
    @State private var showDefaultProfileImage: Bool = false
    @State private var selectedImage: UIImage? = nil
    
    private var urlImageModel: UrlImageModel
    
    init(profileImageUrl: Binding<String?>, sfSymbolName: String, viewOnly: Bool = false) {
        self._profileImageUrl = profileImageUrl
        self.sfSymbolName = sfSymbolName
        self.viewOnly = viewOnly
        self.urlImageModel = UrlImageModel(urlString: profileImageUrl.wrappedValue)
    }
    
        func updateProfileImage() {
            guard
                let image = selectedImage
            else {
                return
            }
    
            Api().uploadImage(image: image) { response in
                if let profileImageUrl = response.profileImageUrl {
                    self.profileImageUrl = profileImageUrl
                    return
                }
                print("Unable to get url for uploaded image")
            }
        }
    
    var body: some View {
        
        Button(action: {
            print("Profile photo tapped")
            self.isShowPhotoLibrary.toggle()
        }) {
            UrlImageView(defaultImageSystemName: sfSymbolName).environmentObject(urlImageModel)
        }
        .frame(minWidth: 0, maxWidth: Constants.textFieldMaxWidth)
        .padding(.top, 80)
        .padding(.bottom, 10)
        .background(Color.themeBackground)
        .foregroundColor(Color.themeForeground)
        .padding(.horizontal, Constants.horizontalPadding)
        .disabled(viewOnly)
        .sheet(isPresented: $isShowPhotoLibrary) {
            
        }
        .sheet(isPresented: $isShowPhotoLibrary, onDismiss: {
            if let _ = selectedImage {
                self.showDefaultProfileImage = false
                updateProfileImage()
            }
            
        }, content: {
            ImagePicker(sourceType: .photoLibrary, allowsEditing: true, selectedImage: $selectedImage)
        })
        
    }
}

struct SvProfileIconView_Previews: PreviewProvider {
    // one of "person.crop.circle.badge.plus" or "person.circle"
    static var previews: some View {
        SvProfileIconView(profileImageUrl: .constant(nil), sfSymbolName: "person.circle")
    }
}
