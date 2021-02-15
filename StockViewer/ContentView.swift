//
//  ContentView.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var appState: AppState
    @State private var createAccount = false
    @State var portfolio = Portfolio()
    
    
    private func isLoggedIn() -> Bool {
        AuthUtils().checkAuthToken()
        appState.isLoggedIn = SettingsManager.sharedInstance.isLoggedIn ?? false
        return appState.isLoggedIn
    }
    
    private func refreshingData() -> Bool {
        if appState.refreshingData {
            loadData()
            return true
        }
        
        return false
    }
    
    private func loadData() {
        if isLoggedIn() {
            appState.isDataLoading = true
            Api().getPortfolio { (portfolio) in
                self.portfolio = portfolio
                self.appState.isDataLoading = false
                self.appState.refreshingData = false
            }
        }
    }
    
    
    var body: some View {
        Group {
            if appState.isLoggedIn {
                if appState.isDataLoading || refreshingData() {
                    GeometryReader { geometry in
                        VStack(alignment: .center) {
                            ProgressView("Loading...")
                                .scaleEffect(1.5, anchor: .center)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.themeAccent))
                        }
                        .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                        .foregroundColor(Color.themeAccent)
                        .opacity(appState.isDataLoading ? 1 : 0)
                        .insetView()
                    }
                } else {
                    HomeView(portfolio: portfolio)
                        .navigationTitle("My Portfolio")
                        .phoneOnlyStackNavigationView()
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
            loadData()
        }
    }
}
