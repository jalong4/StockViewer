//
//  MeneView.swift
//  StockViewer
//
//  Created by Jim Long on 2/9/21.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var appData: AppData
    
    var body: some View {            
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button(action: {
                    appData.showMenu = false
                    appData.showingProfile = true
                    appData.showingEnterTrade = false
                    appData.showingStockTable = false
                    appData.showingEditCash = false
                    appData.showingFutures = false
                    appData.showingSettings = false
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
                    appData.showMenu = false
                    appData.showingProfile = false
                    appData.showingEnterTrade = false
                    appData.showingStockTable = false
                    appData.showingEditCash = false
                    appData.showingFutures = false
                    appData.showingSettings = false
                    appData.showingChangePassword = true
                    print("Change Password")
                    
                }) {
                    Image(systemName: "key")
                        .foregroundColor(Color.themeBackground)
                        .imageScale(.large)
                    Text("Change Password")
                        .padding()
                        .foregroundColor(Color.themeBackground)
                }
            }
            
            HStack {
                Button(action: {
                    appData.showMenu = false
                    appData.showingProfile = false
                    appData.showingEnterTrade = true
                    appData.showingStockTable = false
                    appData.showingEditCash = false
                    appData.showingFutures = false
                    appData.showingSettings = false
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
                    appData.showMenu = false
                    appData.showingProfile = false
                    appData.showingEnterTrade = false
                    appData.showingStockTable = false
                    appData.showingEditCash = true
                    appData.showingFutures = false
                    appData.showingSettings = false
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
                    appData.showMenu = false
                    appData.showingProfile = false
                    appData.showingEnterTrade = false
                    appData.showingStockTable = false
                    appData.showingEditCash = false
                    appData.showingFutures = true
                    appData.showingSettings = false
                    print("Futures")
                    
                }) {
                    Image(systemName: "hourglass.tophalf.fill")
                        .foregroundColor(Color.themeBackground)
                        .imageScale(.large)
                    Text("Futures")
                        .padding()
                        .foregroundColor(Color.themeBackground)
                }
            }
            
            HStack {
                Button(action: {
                    appData.showMenu = false
                    appData.showingProfile = false
                    appData.showingEnterTrade = false
                    appData.showingStockTable = false
                    appData.showingEditCash = false
                    appData.showingFutures = false
                    appData.showingSettings = true
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
                    appData.showMenu.toggle()
                    appData.isLoggedIn.toggle()
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
