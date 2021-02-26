//
//  SettingsView.swift
//  StockViewer
//
//  Created by Jim Long on 2/12/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack() {
            Text("Coming soon...")
            
            Button(action: {
                appState.showingSettings = false
                appState.showingStockTable = true
            }) {
                Text("OK")
                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                    .primaryButtonTextModifier()
            }
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
        }
        .dismissKeyboardOnTap()
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
