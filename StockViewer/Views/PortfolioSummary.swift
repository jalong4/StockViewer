//
//  AccountList.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI

struct PortfolioSummary: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @EnvironmentObject var appState: AppState
    
    @State private var selectedAccountName: String?
    var portfolio: Portfolio
    
    
    func getArray(slice: ArraySlice<StockGains>) -> [StockGains] {
        let result = Array(slice)
        return result
    }
    
    // navigation link for programmatic navigation
    var navigationLink: NavigationLink<EmptyView, StockTableView>? {
        guard let selectedAccountName = selectedAccountName else {
            return nil
        }
        
        return NavigationLink(
            destination: StockTableView(appState: _appState, portfolio: self.portfolio, name: selectedAccountName, type: .account),
            tag: selectedAccountName,
            selection: $selectedAccountName
        ) {
            EmptyView()
        }
    }
    
    var body: some View {
        
        VStack {
            TabView {
                TopMoversView(title: "Top Gainers", portfolio: portfolio, stockGains:Array(portfolio.summary.topDayGainers))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                
                TopMoversView(title: "Top Losers", portfolio: portfolio, stockGains:Array(portfolio.summary.topDayLosers))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                
                TopMoversView(title: "Most Profitable", portfolio: portfolio, stockGains:Array(portfolio.summary.mostProfitable))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                
                TopMoversView(title: "Least Profitable", portfolio: portfolio, stockGains:Array(portfolio.summary.leastProfitable))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)

            }
            .padding(0)
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 90)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                // ~Equivalent to iPhone portrait
                if let totals = self.portfolio.summary.totals {
                    if totals.total > 0 {
                        SummaryView(totals: self.portfolio.summary.totals, title: "Portfolio")
                    }
                }
            }
            
            navigationLink
            
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(self.portfolio.summary.accounts) { account in
                        Button(action: {
                            self.selectedAccountName = account.name
                        }) {
                            AccountView(account: account)
                                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                                .cardBorder()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .onAppear {
            // if in split view, programatically navigate to first account
            
            let size = UIScreen.main.bounds.size
            let isLandscape = size.width > size.height
                
            print("isLandscape: \(isLandscape)")
            if (UIDevice.current.userInterfaceIdiom == .pad) { // && isLandscape {
                appState.stockSortType = .ticker
                self.selectedAccountName = self.portfolio.summary.accounts.first?.name
            }
            
        }
    }
}


struct PortfolioSummary_Previews: PreviewProvider {
    @State static var portfolio = Api.getMockPortfolio()
    static var previews: some View {
        PortfolioSummary(portfolio: portfolio)
    }
}
