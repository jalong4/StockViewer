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
            TopMoversView(portfolio: self.portfolio)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 100, alignment: .center)
            
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
