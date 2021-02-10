//
//  ContentView.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI

struct ContentView: View {
    @State var isLoggedIn = SettingsManager.sharedInstance.isLoggedIn ?? false
    
    var body: some View {
        Group {
            if self.isLoggedIn {
                HomeView()
                    .navigationTitle("My Portfolio")
                    .phoneOnlyStackNavigationView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("AuthStatusChange"), object: nil, queue: .main) { (_) in
                self.isLoggedIn = SettingsManager.sharedInstance.isLoggedIn ?? false
            }
        }
        .onDisappear() {
            NotificationCenter.default.removeObserver("AuthStatusChange")
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
