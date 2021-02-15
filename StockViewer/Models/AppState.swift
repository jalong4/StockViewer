//
//  AppState.swift
//  StockViewer
//
//  Created by Jim Long on 2/12/21.
//

import Combine

class AppState: ObservableObject {
    @Published var navigateToEnterTrade: Bool = false
    @Published var navigateToProfile: Bool = false
    @Published var navigateToSettings: Bool = false
    @Published var isLoggedIn: Bool = true
    @Published var isDataLoading: Bool = true
    @Published var refreshingData: Bool = false
    @Published var showMenu: Bool = false
}
