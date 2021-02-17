//
//  AppState.swift
//  StockViewer
//
//  Created by Jim Long on 2/12/21.
//

import Combine

enum NavitageTo {
    case EnterTrade
    case EditCash
    case Profile
    case Settings
    case Home
}

class AppState: ObservableObject {
    @Published var navigateTo: NavitageTo = .Home
    @Published var isLoggedIn: Bool = true
    @Published var isDataLoading: Bool = true
    @Published var refreshingData: Bool = false
    @Published var showMenu: Bool = false
}
