//
//  appData.swift
//  StockViewer
//
//  Created by Jim Long on 2/12/21.
//

import Combine

class AppData: ObservableObject {

    @Published var showingStockTable: Bool = false
    @Published var showingProfile: Bool = false
    @Published var showingEnterTrade: Bool = false
    @Published var showingEditCash: Bool = false
    @Published var showingSettings: Bool = false
    @Published var showingChangePassword: Bool = false
    @Published var showStocksForPortfolio: Bool = false
    @Published var needsRefreshData: Bool = true
    @Published var isLoggedIn: Bool = true
    @Published var isDataLoading: Bool = true
    @Published var postMarketDataIsAvailable: Bool = false
    @Published var showMenu: Bool = false
    @Published var stockSortType: StockSortType = .ticker
    @Published var stockSortDirection: StockSortDirection = .down
    @Published var portfolio = Portfolio()
}
