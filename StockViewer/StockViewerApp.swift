//
//  StockViewerApp.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI

@main
struct StockViewerApp: App {
    
    private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appState)
        }
    }
}
