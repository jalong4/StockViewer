//
//  MeneView.swift
//  StockViewer
//
//  Created by Jim Long on 2/9/21.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {            
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button(action: {
                    withAnimation {
                        appState.showMenu.toggle()
                    }
                    appState.navigateTo = .Profile
                    print("Profile")
                }) {
                    Image(systemName: "person")
                        .foregroundColor(Color.themeBackground)
                        .imageScale(.large)
                    Text("Profile")
                        .padding()
                        .foregroundColor(Color.themeBackground)
                }
            }
            .padding(.top, 100)
            
            HStack {
                Button(action: {
                    withAnimation {
                        appState.showMenu.toggle()
                    }
                    appState.navigateTo = .EnterTrade
                    print("Enter Trade")
                    
                }) {
                    Image(systemName: "arrow.left.arrow.right")
                        .foregroundColor(Color.themeBackground)
                        .imageScale(.large)
                    Text("Enter Trade")
                        .padding()
                        .foregroundColor(Color.themeBackground)
                }
            }
            
            HStack {
                Button(action: {
                    withAnimation {
                        appState.showMenu.toggle()
                    }
                    appState.navigateTo = .EditCash
                    print("Edit Cash Balance")
                    
                }) {
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(Color.themeBackground)
                        .imageScale(.large)
                    Text("Edit Cash Balance")
                        .padding()
                        .foregroundColor(Color.themeBackground)
                }
            }
            
            HStack {
                Button(action: {
                    withAnimation {
                        appState.showMenu.toggle()
                    }
                    appState.navigateTo = .Settings
                    print("Settings")
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(Color.themeBackground)
                        .imageScale(.large)
                    Text("Settings")
                        .padding()
                        .foregroundColor(Color.themeBackground)
                }
            }
            
            HStack {
                Button(action: {
                    print("Logging out")
                    appState.showMenu.toggle()
                    appState.isLoggedIn.toggle()
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
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.themeAccent)
        .edgesIgnoringSafeArea(.all)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
