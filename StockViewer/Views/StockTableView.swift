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
    @EnvironmentObject var appState: AppState

    
    var portfolio: Portfolio
    var name: String
    var type: StockTableType
    
    func getTitle() -> String {
        var stockName = "";
        if (type == .stock) {
            let stocks = self.portfolio.stocks.filter{ $0.ticker == self.name }
            if (stocks.count > 0) {
                stockName = stocks[0].name
            }
        }
        return (type == StockTableType.account) ? "\(self.name) Account" : "\(stockName)"
    }
    
    func getAccount() -> Account {
        return self.portfolio.summary.accounts.filter{ $0.name == self.name }[0]
    }
    
    func getStocks(stockSortType: StockSortType) -> [Stock] {
        
        switch self.type {
        case .account:
            var stocks = self.portfolio.stocks.filter{ $0.account == self.name }
            let postMarketDataIsAvailable = !stocks.allSatisfy{ $0.postMarketGain == 0 }
            if self.appState.postMarketDataIsAvailable != postMarketDataIsAvailable {
                self.appState.postMarketDataIsAvailable.toggle()
            }
            
            stocks.sort(by: {(a, b) -> Bool in
                switch appState.stockSortType {
                case .name:
                    return (a.name < b.name)
                case .percentChange:
                    return (a.percentChange > b.percentChange)
                case .priceChange:
                    return (a.priceChange ?? 0 > b.priceChange ?? 0)
                case .dayGain:
                    return (a.dayGain > b.dayGain)
                case .totalCost:
                    return (a.totalCost > b.totalCost)
                case .profit:
                    return (a.profit > b.profit)
                case .total:
                    return (a.total > b.total)
                case .percentProfit:
                    return (a.percentProfit > b.percentProfit)
                case .postMarketChangePercent:
                    return (a.postMarketChangePercent > b.postMarketChangePercent)
                case .postMarketChange:
                    return (a.postMarketChange > b.postMarketChange)
                case .postMarketGain:
                    return (a.postMarketGain > b.postMarketGain)
                case .ticker:
                    return (a.ticker < b.ticker) || (a.name == "Cash")
                }
            })
            return stocks;
        case .stock:
            let stocks = self.portfolio.stocks.filter{ $0.ticker == self.name }
            let postMarketDataIsAvailable = !stocks.allSatisfy{ $0.postMarketGain == 0 }
            if self.appState.postMarketDataIsAvailable != postMarketDataIsAvailable {
                self.appState.postMarketDataIsAvailable.toggle()
            }
            return stocks
        }
    }
    
    func getHeader() -> some View {
        return
                HStack {
                    
                    StockTableRow(
                        price: AnyView(Text("Price").fontWeight(.bold)),
                        quantity: AnyView(Text("Qty").fontWeight(.bold)),
                        percentChange: AnyView(
                            Button(action: {
                                print("Sorting by percentChange")
                                appState.stockSortType = (appState.stockSortType == .percentChange) ? .ticker : .percentChange
                            }) {
                                Text("\u{0394}" + " (%)").underline(appState.stockSortType == .percentChange, color: .black)
                                    .fontWeight(.bold)
                            }),
                        priceChange: AnyView(
                            Button(action: {
                                print("Sorting by priceChange")
                                appState.stockSortType = (appState.stockSortType == .priceChange) ? .ticker : .priceChange
                            }) {
                                Text("\u{0394}" + " ($)").underline(appState.stockSortType == .priceChange, color: .black)
                                    .fontWeight(.bold)
                            }),
                        dayGain: AnyView(
                            Button(action: {
                                print("Sorting by dayGain")
                                appState.stockSortType = (appState.stockSortType == .dayGain) ? .ticker : .dayGain
                            }) {
                                Text("Day Gain").underline(appState.stockSortType == .dayGain, color: .black)
                                    .fontWeight(.bold)
                            }),
                        unitCost: AnyView(Text("Unit Cost").fontWeight(.bold)),
                        totalCost: AnyView(
                            Button(action: {
                                print("Sorting by totalCost")
                                appState.stockSortType = (appState.stockSortType == .totalCost) ? .ticker : .totalCost
                            }) {
                                Text("Total Cost").underline(appState.stockSortType == .totalCost, color: .black)
                                    .fontWeight(.bold)
                            }),
                        profit: AnyView(
                            Button(action: {
                                print("Sorting by profit")
                                appState.stockSortType = (appState.stockSortType == .profit) ? .ticker : .profit
                            }) {
                                Text("Profit ($)").underline(appState.stockSortType == .profit, color: .black)
                                    .fontWeight(.bold)
                            }),
                        total: AnyView(
                            Button(action: {
                                print("Sorting by total")
                                appState.stockSortType = (appState.stockSortType == .total) ? .ticker : .total
                            }) {
                                Text("Total")
                                    .underline(appState.stockSortType == .total, color: .black)
                                    .fontWeight(.bold)
                            }),
                        percentProfit: AnyView(
                            Button(action: {
                                print("Sorting by percentProfit")
                                appState.stockSortType = (appState.stockSortType == .percentProfit) ? .ticker : .percentProfit
                            }) {
                                Text("Profit (%)")
                                    .underline(appState.stockSortType == .percentProfit, color: .black)
                                    .fontWeight(.bold)
                            }),
                        postMarketPrice: AnyView(Text("Post Price").fontWeight(.bold)),
                        postMarketChangePercent: AnyView(
                            Button(action: {
                                print("Sorting by postMarketChangePercent")
                                appState.stockSortType = (appState.stockSortType == .postMarketChangePercent) ? .ticker : .postMarketChangePercent
                            }) {
                                Text("Post " + "\u{0394}" + " (%)")
                                    .underline(appState.stockSortType == .postMarketChangePercent, color: .black)
                                    .fontWeight(.bold)
                            }),
                        postMarketChange: AnyView(
                            Button(action: {
                                print("Sorting by postMarketChange")
                                appState.stockSortType = (appState.stockSortType == .postMarketChange) ? .ticker : .postMarketChange
                            }) {
                                Text("Post " + "\u{0394}" + " ($)")
                                    .underline(appState.stockSortType == .postMarketChange, color: .black)
                                    .fontWeight(.bold)
                            }),
                        postMarketGain: AnyView(
                            Button(action: {
                                print("Sorting by postMarketGain")
                                appState.stockSortType = (appState.stockSortType == .dayGain) ? .ticker : .postMarketGain
                            }) {
                                Text("Post Gain").underline(appState.stockSortType == .postMarketGain, color: .black)
                                    .fontWeight(.bold)
                            }),
                        type: type
                    )
                    .environmentObject(appState)
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
    
    func getFooter(stocks: [Stock]) -> some View {
        let totals = ((self.type == .account) ? getAccount() : getFooterForStock(stocks: stocks))
        return
            StockTableRow(
                price: AnyView(Text("")),
                quantity: AnyView(Text(type == .stock ? Utils.getFormattedNumber(totals.quantity ?? 0) : "").fontWeight(.bold)),
                percentChange: AnyView(Utils.getColorCodedTextView(totals.percentChange, style: .percent).fontWeight(.bold)),
                priceChange: AnyView(Text("")),
                dayGain: AnyView(Utils.getColorCodedTextView(totals.dayGain, style: .decimal).fontWeight(.bold)),
                unitCost: AnyView(Text("")),
                totalCost: AnyView(Text(Utils.getFormattedNumber(totals.totalCost)).fontWeight(.bold)),
                profit: AnyView(Utils.getColorCodedTextView(totals.profit, style: .decimal).fontWeight(.bold)),
                total: AnyView(Text(Utils.getFormattedNumber(totals.total)).fontWeight(.bold)),
                percentProfit: AnyView(Utils.getColorCodedTextView(totals.percentProfit, style: .percent).fontWeight(.bold)),
                postMarketPrice: AnyView(Text("")),
                postMarketChangePercent: AnyView(Utils.getColorCodedTextView(totals.postMarketChangePercent, style: .percent).fontWeight(.bold)),
                postMarketChange: AnyView(Text("")),
                postMarketGain: AnyView(Utils.getColorCodedTextView(totals.postMarketGain, style: .decimal).fontWeight(.bold)),
                type: type
            )
            .environmentObject(appState)
    }
    
    var body: some View {
        
        let rowHeight: CGFloat = 38
        
        ScrollView(.vertical) {
            
            if horizontalSizeClass == .compact
                && verticalSizeClass == .regular
                && self.type == StockTableType.account {
                SummaryView(totals: getAccount())
            }
            
            let stocks = getStocks(stockSortType: appState.stockSortType)
            
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                Text("Stocks")
                    .fontWeight(.bold)
                    .font(.system(size:20))
                    .padding(EdgeInsets(top: 2, leading: 0, bottom: 10, trailing: 0))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text(type == .account ? "Name" : "Account").fontWeight(.bold)
                            .frame(width: ((type == .account) ? 120 : 100), alignment: .topLeading)
                            .frame(height: rowHeight)
                        
                        ForEach(stocks) { stock in
                            VStack(alignment: .leading, spacing: 0) {
                                Text(type == .stock ? stock.account : (stock.name == "Cash") ? "Cash" : stock.ticker)
                                Text(type == .stock || stock.name == "Cash" ? "Cash Account" : stock.name).fontWeight(.regular).font(.system(size: 12))
                            }
                            .frame(width: (type == .account) ? 120 : 120, height: rowHeight, alignment: .topLeading)

                        }
                        
                        Text("Total").fontWeight(.bold).font(.system(size: 14))
                            .frame(width: ((type == .account) ? 120 : 120), alignment: .topLeading)

                    }
                    
                    VStack(spacing: 0)  {
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            getHeader()
                                .frame(height: rowHeight)
                            
                            ForEach(stocks) { stock in
                                StockTableRow(price: AnyView(Text(Utils.getFormattedNumber(stock.price))),
                                              quantity: AnyView(Text(Utils.getFormattedNumber(stock.quantity))),
                                              percentChange: AnyView(Utils.getColorCodedTextView(stock.percentChange, style: .percent)),
                                              priceChange: AnyView(Utils.getColorCodedTextView(stock.priceChange ?? 0, style: .decimal)),
                                              dayGain: AnyView(Utils.getColorCodedTextView(stock.dayGain, style: .decimal)),
                                              unitCost: AnyView(Text(Utils.getFormattedNumber(stock.unitCost))),
                                              totalCost: AnyView(Text(Utils.getFormattedNumber(stock.totalCost))),
                                              profit: AnyView(Utils.getColorCodedTextView(stock.profit, style: .decimal)),
                                              total: AnyView(Text(Utils.getFormattedNumber(stock.total))),
                                              percentProfit: AnyView(Utils.getColorCodedTextView(stock.percentProfit, style: .percent)),
                                              postMarketPrice: AnyView(Text(Utils.getFormattedNumber(stock.postMarketPrice))),
                                              postMarketChangePercent: AnyView(Utils.getColorCodedTextView(stock.postMarketChangePercent, style: .percent)),
                                              postMarketChange: AnyView(Utils.getColorCodedTextView(stock.postMarketChange, style: .decimal)),
                                              postMarketGain: AnyView(Utils.getColorCodedTextView(stock.postMarketGain, style: .decimal)),
                                              type: type
                                )
                                .environmentObject(appState)
                                .frame(height: rowHeight)
                            }
                            
                            getFooter(stocks: stocks)
                        }
                        
                    }
                    
                }
            }
            .padding([.leading, .trailing], 20)
        }
        .navigationTitle("\(getTitle())")
        
    }
}

//struct StockTableView_Previews: PreviewProvider {
//    
//    @State static var portfolio = Api.getMockPortfolio()
//
//    static var previews: some View {
//        StockTableView(portfolio: portfolio, name: "Fidelity", type: .account, appState: )
//    }
//}
