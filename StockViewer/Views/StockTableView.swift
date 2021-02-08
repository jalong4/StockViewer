//
//  StockTableView.swift
//  StockViewer
//
//  Created by Jim Long on 2/6/21.
//

import SwiftUI

struct StockTableView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var portfolio: Portfolio
    var name: String
    var type: StockTableType
    
    func getTitle() -> String {
        return (self.type == StockTableType.account) ? "\(self.name) Account" : "\(self.name)"
    }
    
    func getAccount() -> Account {
        return self.portfolio.summary.accounts.filter{ $0.name == self.name }[0]
    }
    
    func getStocks() -> [Stock] {
        switch self.type {
        case .account:
            var stocks = self.portfolio.stocks.filter{ $0.account == self.name }
            stocks.sort(by: {(a, b) -> Bool in
                return (a.ticker < b.ticker) || (a.name == "Cash")
            })
            return stocks;
        case .stock:
            return self.portfolio.stocks.filter{ $0.ticker == self.name }
        }
    }
    
    func getFooterForStock (stocks: [Stock]) -> Account {
        
        var result = Account()
  
        result.quantity = stocks.reduce(0) { (sum, a) -> Double in sum + a.quantity }
        result.total = stocks.reduce(0) { (sum, a) -> Double in sum + a.total }
        result.totalCost = stocks.reduce(0) { (sum, a) -> Double in sum + a.totalCost }
        result.postMarketGain = stocks.reduce(0) { (sum, a) -> Double in sum + a.postMarketGain }
        
        result.dayGain = stocks.reduce(0) { (sum, a) -> Double in sum + a.dayGain }
        result.profit = stocks.reduce(0) { (sum, a) -> Double in sum + a.profit }
        result.percentChange = ((result.total - result.dayGain) == 0) ? 0 : (result.dayGain / (result.total - result.dayGain));
        result.percentProfit = (result.totalCost == 0) ? ((result.profit == 0) ? 0 : 1) : (result.profit / result.totalCost);
        result.postMarketChangePercent = (result.total == 0) ? 0 : (result.postMarketGain / result.total);
        
        return result
    }
    
    func getSummaryForAccount () -> some View {
        
        return SummaryView(totals: getAccount())
            .padding(EdgeInsets(top: 2, leading: 10, bottom: 10, trailing: 10))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 140, alignment: .topLeading)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 222/255, green: 222/255, blue: 222/255), lineWidth: 1))
    }
    
    
    func getFooter(stocks: [Stock]) -> some View {
        let totals = ((self.type == .account) ? getAccount() : getFooterForStock(stocks: stocks))
        return
            StockTableRow(rowName: Text("Total").fontWeight(.bold).font(.system(size: 14)),
                          price: Text(""),
                          quantity: Text(type == .stock ? Utils.getFormattedNumber(totals.quantity ?? 0) : "").fontWeight(.bold),
                          percentChange: Utils.getColorCodedTextView(totals.percentChange, style: .percent).fontWeight(.bold),
                          priceChange: Text(""),
                          dayGain: Utils.getColorCodedTextView(totals.dayGain, style: .decimal).fontWeight(.bold),
                          unitCost: Text(""),
                          totalCost: Text(Utils.getFormattedNumber(totals.totalCost)).fontWeight(.bold),
                          profit: Utils.getColorCodedTextView(totals.profit, style: .decimal).fontWeight(.bold),
                          total: Text(Utils.getFormattedNumber(totals.total)).fontWeight(.bold),
                          percentProfit: Utils.getColorCodedTextView(totals.percentProfit, style: .percent).fontWeight(.bold),
                          ticker: Text(""),
                          type: type
            )
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
    }
    
    
    func getHeader() -> some View {
        return
            
            VStack(alignment: .leading) {
                
                Text("Stocks")
                    .fontWeight(.bold)
                    .font(.system(size:20))
                    .padding(EdgeInsets(top: 2, leading: 0, bottom: 10, trailing: 0))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                
                StockTableRow(rowName: Text("Name").fontWeight(.bold),
                              price: Text("Price").fontWeight(.bold),
                              quantity: Text("Qty").fontWeight(.bold),
                              percentChange: Text("\u{0394}" + " (%)").fontWeight(.bold),
                              priceChange: Text("\u{0394}" + " ($)").fontWeight(.bold),
                              dayGain: Text("Day Gain").fontWeight(.bold),
                              unitCost: Text("Unit Cost").fontWeight(.bold),
                              totalCost: Text("Total Cost").fontWeight(.bold),
                              profit: Text("Profit ($)").fontWeight(.bold),
                              total: Text("Total").fontWeight(.bold),
                              percentProfit: Text("Profit (%)").fontWeight(.bold),
                              ticker: Text("Ticker").fontWeight(.bold),
                              type: type
                )
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
    }
    
    var body: some View {
        ScrollView(.vertical) {
            
            if horizontalSizeClass == .compact
                && verticalSizeClass == .regular
                && self.type == StockTableType.account {
                getSummaryForAccount().padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            
            let stocks = getStocks()
            
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                ScrollView(.horizontal) {
                    Section(header: getHeader(), footer: getFooter(stocks: stocks)) {
                        ForEach(stocks) { stock in
                            
                            HStack {
                                StockTableRow(rowName: Text(stock.name).font(.system(size: 14)),
                                              price: Text(Utils.getFormattedNumber(stock.price)),
                                              quantity: Text(Utils.getFormattedNumber(stock.quantity)),
                                              percentChange: Utils.getColorCodedTextView(stock.percentChange, style: .percent),
                                              priceChange: Utils.getColorCodedTextView(stock.priceChange ?? 0, style: .decimal),
                                              dayGain: Utils.getColorCodedTextView(stock.dayGain, style: .decimal),
                                              unitCost: Text(Utils.getFormattedNumber(stock.unitCost)),
                                              totalCost: Text(Utils.getFormattedNumber(stock.totalCost)),
                                              profit: Utils.getColorCodedTextView(stock.profit, style: .decimal),
                                              total: Text(Utils.getFormattedNumber(stock.total)),
                                              percentProfit: Utils.getColorCodedTextView(stock.percentProfit, style: .percent),
                                              ticker: Text(stock.ticker),
                                              type: type
                                              
                                )
                            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 140, alignment: .topLeading)
                        }
                    }
                    
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .navigationTitle("\(getTitle())")
        
    }
}

struct StockTableView_Previews: PreviewProvider {
    
    @State static var portfolio = Api.getMockPortfolio()
    static var previews: some View {
        StockTableView(portfolio: portfolio, name: "Fidelity", type: .account)
    }
}
