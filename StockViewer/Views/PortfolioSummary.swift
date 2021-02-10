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
    
    
    var portfolio: Portfolio

    var body: some View {
        VStack {
            TabView {
                TopMoversView(title: "Top Gainers", portfolio: portfolio, stockGains:portfolio.summary.topDayGainers)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                TopMoversView(title: "Top Losers", portfolio: portfolio, stockGains:portfolio.summary.topDayLosers)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                TopMoversView(title: "Most Profitable", portfolio: portfolio, stockGains:portfolio.summary.mostProfitable)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                TopMoversView(title: "Least Profitable", portfolio: portfolio, stockGains:portfolio.summary.leastProfitable)
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
                        SummaryView(totals: self.portfolio.summary.totals, title: "My Portfolio")
                    }
                }
            }
            
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(self.portfolio.summary.accounts) { account in
                        NavigationLink(destination: StockTableView(portfolio: portfolio, name: account.name, type: .account)) {
                            AccountView(account: account)
                                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                                .cardBorder()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}


struct PortfolioSummary_Previews: PreviewProvider {
    @State static var portfolio = Api.getMockPortfolio();
    static var previews: some View {
        PortfolioSummary(portfolio: portfolio)
    }
}
