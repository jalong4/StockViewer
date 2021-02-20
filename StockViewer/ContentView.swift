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
    
    private func loadData() {
        if isLoggedIn() {
            appState.isDataLoading = true
            Api().getPortfolio { (portfolio) in
                self.portfolio = portfolio
                self.appState.isDataLoading = false
            }
        }
    }
    
    
    var body: some View {
        Group {
            if appState.isLoggedIn {
                if appState.isDataLoading {
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
                        .environmentObject(appState)
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
