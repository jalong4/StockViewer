//
//  ContentView.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var appData: AppData
    @State private var createAccount = false
    
    
    private func isLoggedIn() -> Bool {
        AuthUtils().checkAuthToken()
        appData.isLoggedIn = SettingsManager.sharedInstance.isLoggedIn ?? false
        return appData.isLoggedIn
    }
    
    private func loadData() {
        if isLoggedIn() {
            if appData.isNetworkReachable {
                appData.isDataLoading = true
                Api().getPortfolio { (portfolio) in
                    appData.portfolio = portfolio
                    self.appData.isDataLoading = false
                }
            }
            else {
                appData.isDataLoading = false
            }
        }
    }
    
    
    var body: some View {
        Group {
            if appData.isLoggedIn {
                if !appData.isNetworkReachable {
                    GeometryReader { geometry in
                        VStack(alignment: .center) {
                            Text("No Network Connection")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                        }
                        .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                        .foregroundColor(Color.themeAccent)
                        .insetView()
                    }
                }
                else if appData.isDataLoading {
                    GeometryReader { geometry in
                        VStack(alignment: .center) {
                            ProgressView("Loading...")
                                .scaleEffect(1.5, anchor: .center)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.themeAccent))
                        }
                        .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                        .foregroundColor(Color.themeAccent)
                        .opacity(appData.isDataLoading ? 1 : 0)
                        .insetView()
                    }
                } else {
                    HomeView()
                        .environmentObject(appData)
                }
            } else {
                if createAccount {
                    RegisterView(createAccount: $createAccount)
                } else {
                    LoginView(createAccount: $createAccount)
                }
            }
        }
        .onAppear() {
            if appData.needsRefreshData {
                appData.needsRefreshData.toggle()
                print("Refreshing data")
                self.loadData()
            }
        }
    }
}
