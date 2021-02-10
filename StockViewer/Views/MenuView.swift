//
//  MeneView.swift
//  StockViewer
//
//  Created by Jim Long on 2/9/21.
//

import SwiftUI

struct MenuView: View {
    
    @Binding var showMenu: Bool
    @State var isLoggedIn = SettingsManager.sharedInstance.isLoggedIn ?? false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person")
                    .foregroundColor(Color.themeBackground)
                    .imageScale(.large)
                Text("Profile")
                    .foregroundColor(Color.themeBackground)
                    .font(.headline)
            }
            .padding(.top, 100)
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(Color.themeBackground)
                    .imageScale(.large)
                Text("Messages")
                    .foregroundColor(Color.themeBackground)
                    .font(.headline)
            }
            .padding(.top, 30)
            HStack {
                Image(systemName: "gear")
                    .foregroundColor(Color.themeBackground)
                    .imageScale(.large)
                Text("Settings")
                    .foregroundColor(Color.themeBackground)
                    .font(.headline)
            }
            .padding(.top, 30)
            HStack {
                Button(action: {
                    print("Logging out")
                    AuthUtils().logOut()
                }) {
                    Image(systemName: "power")
                        .foregroundColor(Color.themeBackground)
                        .imageScale(.large)
                    Text("Logout")
                    .padding()
                    .foregroundColor(Color.themeBackground)
                }
            }
            .padding(.top, 30)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.themeAccent)
        .edgesIgnoringSafeArea(.all)
    }
}

//struct MenuView_Previews: PreviewProvider {
//    @State var showMenu: Bool
//    static var previews: some View {
//        MenuView(showMenu: showMenu)
//    }
//}
