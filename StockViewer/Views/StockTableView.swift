//
//  StockTableView.swift
//  StockViewer
//
//  Created by Jim Long on 2/6/21.
//

import SwiftUICharts
import SwiftUI

struct StockTableView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @EnvironmentObject var appData: AppData
    
    @State var name: String
    @State var type: StockTableType
    @State var chart = Chart()
    
    
    func getStockChartData() {
        if type == .stock && self.chart.quotes.isEmpty && name != Constants.cashTicker {
            Api().getStockChart(ticker: self.name) { (chartResponse) in
                print("\(self.name)")
                if let chartResponse = chartResponse {
                    if let chart = chartResponse.chart {
                        self.chart = chart
                        print("Avg Stock Price: \(chart.avgPrice)")
//                        for quote in chart.quotes {
//                            print("\(quote.description)")
//                        }
                        print("Stock Chart call successful")
                    } else {
                        if let errors = chartResponse.errors {
                            print("Stock Chart call had errors")
                            for error in errors {
                                print("\(error.msg)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func getTitle() -> String {
        var stockName = "";
        if (type == .stock) {
            let stocks = appData.portfolio.stocks.filter{ $0.ticker == self.name }
            if (stocks.count > 0) {
                stockName = stocks[0].name ?? stocks[0].ticker
            }
        }
        return (type == StockTableType.account) ? "\(self.name) Account" : "\(stockName)"
    }
    
    func getAccount() -> Account {
        var result = appData.portfolio.summary.accounts.filter{ $0.name == self.name }[0]
        let accountStocks = appData.portfolio.stocks.filter{ $0.account == self.name }
        result.percentOfTotalCost = accountStocks.reduce(0) { (sum, a) -> Double in sum + a.percentOfTotalCost }
        result.percentOfTotal = accountStocks.reduce(0) { (sum, a) -> Double in sum + a.percentOfTotal }
        return result;
    }
    
    func checkForPostMarketData(_ stocks: [Stock]) {
        let postMarketDataIsAvailable = !stocks.allSatisfy{ $0.postMarketGain == 0 }
        if appData.postMarketDataIsAvailable != postMarketDataIsAvailable {
            appData.postMarketDataIsAvailable.toggle()
        }
    }
    
    func getStocks(name: String, stockSortType: StockSortType) -> [Stock] {
        switch self.type {
        case .account:
            var stocks = appData.showStocksForPortfolio
                ? appData.portfolio.portfolioStocks
                : appData.portfolio.stocks.filter{ $0.account == name }

            checkForPostMarketData(stocks)
            
            stocks.sort(by: {(a, b) -> Bool in
                switch appData.stockSortType {
                case .name:
                    return appData.stockSortDirection == .up ? (a.name! > b.name!) : (a.name! <= b.name!)
                case .percentChange:
                    return appData.stockSortDirection == .up ? (a.percentChange > b.percentChange) : (a.percentChange <= b.percentChange)
                case .priceChange:
                    return appData.stockSortDirection == .up ? (a.priceChange ?? 0 > b.priceChange ?? 0) : (a.priceChange ?? 0 <= b.priceChange ?? 0)
                case .dayGain:
                    return appData.stockSortDirection == .up ? (a.dayGain > b.dayGain) : (a.dayGain <= b.dayGain)
                case .totalCost:
                    return appData.stockSortDirection == .up ? (a.totalCost > b.totalCost) : (a.totalCost <= b.totalCost)
                case .percentOfTotalCost:
                    return appData.stockSortDirection == .up ? (a.percentOfTotalCost > b.percentOfTotalCost) : (a.percentOfTotalCost <= b.percentOfTotalCost)
                case .profit:
                    return appData.stockSortDirection == .up ? (a.profit > b.profit) :  (a.profit <= b.profit)
                case .total:
                    return appData.stockSortDirection == .up ? (a.total > b.total) : (a.total < b.total)
                case .percentOfTotal:
                    return appData.stockSortDirection == .up ? (a.percentOfTotal > b.percentOfTotal) : (a.percentOfTotal <= b.percentOfTotal)
                case .percentProfit:
                    return appData.stockSortDirection == .up ? (a.percentProfit > b.percentProfit) : (a.percentProfit <= b.percentProfit)
                case .postMarketChangePercent:
                    return appData.stockSortDirection == .up ? (a.postMarketChangePercent > b.postMarketChangePercent) : (a.postMarketChangePercent <= b.postMarketChangePercent)
                case .postMarketChange:
                    return appData.stockSortDirection == .up ? (a.postMarketChange > b.postMarketChange): (a.postMarketChange <= b.postMarketChange)
                case .postMarketGain:
                    return appData.stockSortDirection == .up ? (a.postMarketGain > b.postMarketGain) : (a.postMarketGain <= b.postMarketGain)
                case .ticker:
                    return appData.stockSortDirection == .up ? (a.ticker > b.ticker) || (a.name != "Cash") : (a.ticker <= b.ticker) || (a.name == "Cash")
                }
            })
            print("returning stocks for account")
            return stocks;
        case .stock:
            let ticker = name == "Cash" ? "SPAXX" : name
            var stocks = appData.portfolio.stocks.filter{ $0.ticker == ticker }
            let totals = getFooterForStock(stocks: stocks)
            for (i, _) in stocks.enumerated() {
                stocks[i].percentOfTotalCost = (totals.totalCost == 0) ? 0 : stocks[i].totalCost / totals.totalCost;
                stocks[i].percentOfTotal = (totals.total == 0) ? 0 : stocks[i].total / totals.total;
                if stocks[i].name == "" {
                    stocks[i].name = stocks[i].ticker
                }
            }
            checkForPostMarketData(stocks)
            getStockChartData()
            print("returning all accounts for stocks")
            return stocks
        }
    }
    func updateSortProperties(_ thisType: StockSortType) {
        if appData.stockSortType == thisType {
            if appData.stockSortDirection == .up {
                appData.stockSortDirection = .down
            } else {
                appData.stockSortType = .ticker
                appData.stockSortDirection = .down
            }
        } else {
            appData.stockSortType = thisType
            appData.stockSortDirection = .up
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
                            updateSortProperties(.percentChange)
                        }) {
                            let label = ("\u{0394}" + " (%)").sortPrefix(appData.stockSortType == .percentChange, appData.stockSortDirection)
                            Text(label).fontWeight(.bold)
                        }),
                    priceChange: AnyView(
                        Button(action: {
                            print("Sorting by priceChange")
                            updateSortProperties(.priceChange)
                        }) {
                            let label = ("\u{0394}" + " ($)").sortPrefix(appData.stockSortType == .priceChange, appData.stockSortDirection)
                            Text(label).fontWeight(.bold)
                        }),
                    dayGain: AnyView(
                        Button(action: {
                            print("Sorting by dayGain")
                            updateSortProperties(.dayGain)
                        }) {
                            let label = "Day Gain".sortPrefix(appData.stockSortType == .dayGain, appData.stockSortDirection)
                            Text(label).fontWeight(.bold)
                        }),
                    unitCost: AnyView(Text("Unit Cost").fontWeight(.bold)),
                    totalCost: AnyView(
                        Button(action: {
                            print("Sorting by totalCost")
                            updateSortProperties(.totalCost)
                        }) {
                            let label = "Total Cost".sortPrefix(appData.stockSortType == .totalCost, appData.stockSortDirection)
                            Text(label).fontWeight(.bold)
                        }),
                    percentOfTotalCost: AnyView(
                        Button(action: {
                            print("Sorting by percentOfTotalCost")
                            updateSortProperties(.percentOfTotalCost)
                        }) {
                            let label = "% of Cost".sortPrefix(appData.stockSortType == .percentOfTotalCost, appData.stockSortDirection)
                            Text(label).fontWeight(.bold)
                        }),
                    profit: AnyView(
                        Button(action: {
                            print("Sorting by profit")
                            updateSortProperties(.profit)
                        }) {
                            let label = "Profit ($)".sortPrefix(appData.stockSortType == .profit, appData.stockSortDirection)
                            Text(label).fontWeight(.bold)
                        }),
                    total: AnyView(
                        Button(action: {
                            print("Sorting by total")
                            updateSortProperties(.total)
                        }) {
                            let label = "Total".sortPrefix(appData.stockSortType == .total, appData.stockSortDirection)
                            Text(label).fontWeight(.bold)
                        }),
                    percentOfTotal: AnyView(
                        Button(action: {
                            print("Sorting by percentOfTotal")
                            updateSortProperties(.percentOfTotal)
                        }) {
                            let label = "% of Total".sortPrefix(appData.stockSortType == .percentOfTotal, appData.stockSortDirection)
                            Text(label).fontWeight(.bold)
                        }),
                    percentProfit: AnyView(
                        Button(action: {
                            print("Sorting by percentProfit")
                            updateSortProperties(.percentProfit)
                        }) {
                            let label = "Profit (%)".sortPrefix(appData.stockSortType == .percentProfit, appData.stockSortDirection)
                            Text(label).fontWeight(.bold)
                        }),
                    postMarketPrice: AnyView(Text("Post Price").fontWeight(.bold)),
                    postMarketChangePercent: AnyView(
                        Button(action: {
                            print("Sorting by postMarketChangePercent")
                            updateSortProperties(.postMarketChangePercent)
                        }) {
                            let label = ("Post " + "\u{0394}" + " (%)").sortPrefix(appData.stockSortType == .postMarketChangePercent, appData.stockSortDirection)
                            Text(label).fontWeight(.bold)
                        }),
                    postMarketChange: AnyView(
                        Button(action: {
                            print("Sorting by postMarketChange")
                            updateSortProperties(.postMarketChange)
                        }) {
                            let label = ("Post " + "\u{0394}" + " ($)").sortPrefix(appData.stockSortType == .postMarketChange, appData.stockSortDirection)
                            Text(label).fontWeight(.bold)
                        }),
                    postMarketGain: AnyView(
                        Button(action: {
                            print("Sorting by postMarketGain")
                            updateSortProperties(.postMarketGain)
                        }) {
                            let label = "Post Gain".sortPrefix(appData.stockSortType == .postMarketGain, appData.stockSortDirection)
                            Text(label).fontWeight(.bold)
                        }),
                    type: type
                )
                .environmentObject(appData)
            }
    }
    
    func getFooterForStock (stocks: [Stock]) -> Account {
        
        var result = Account()
        
        result.quantity = stocks.reduce(0) { (sum, a) -> Double in sum + a.quantity }
        result.total = stocks.reduce(0) { (sum, a) -> Double in sum + a.total }
        result.totalCost = stocks.reduce(0) { (sum, a) -> Double in sum + a.totalCost }
        
        if let quantity = result.quantity, quantity != 0 {
            result.unitCost = result.totalCost / quantity
        }
        result.postMarketGain = stocks.reduce(0) { (sum, a) -> Double in sum + a.postMarketGain }
        
        result.dayGain = stocks.reduce(0) { (sum, a) -> Double in sum + a.dayGain }
        result.percentOfTotalCost = stocks.reduce(0) { (sum, a) -> Double in sum + a.percentOfTotalCost }
        result.percentOfTotal = stocks.reduce(0) { (sum, a) -> Double in sum + a.percentOfTotal }
        result.profit = stocks.reduce(0) { (sum, a) -> Double in sum + a.profit }
        result.percentChange = ((result.total - result.dayGain) == 0) ? 0 : (result.dayGain / (result.total - result.dayGain));
        result.percentProfit = (result.totalCost == 0) ? ((result.profit == 0) ? 0 : 1) : (result.profit / result.totalCost);
        result.postMarketChangePercent = (result.total == 0) ? 0 : (result.postMarketGain / result.total);
        
        return result
    }
    
    func getFooter(stocks: [Stock]) -> some View {
        let totals = ((self.type == .account && !appData.showStocksForPortfolio) ? getAccount() : getFooterForStock(stocks: stocks))
        return
            StockTableRow(
                price: AnyView(Text("")),
                quantity: AnyView(Text(type == .stock ? Utils.getFormattedNumber(totals.quantity ?? 0) : "").fontWeight(.bold)),
                percentChange: AnyView(Utils.getColorCodedTextView(totals.percentChange, style: .percent).fontWeight(.bold)),
                priceChange: AnyView(Text("")),
                dayGain: AnyView(Utils.getColorCodedTextView(totals.dayGain, style: .decimal).fontWeight(.bold)),
                unitCost: AnyView(Text(type == .stock ? Utils.getFormattedNumber(totals.unitCost) : "").fontWeight(.bold)),
                totalCost: AnyView(Text(Utils.getFormattedNumber(totals.totalCost)).fontWeight(.bold)),
                percentOfTotalCost: AnyView(Utils.getColorCodedTextView(totals.percentOfTotalCost, style: .percent).fontWeight(.bold)),
                profit: AnyView(Utils.getColorCodedTextView(totals.profit, style: .decimal).fontWeight(.bold)),
                total: AnyView(Text(Utils.getFormattedNumber(totals.total)).fontWeight(.bold)),
                percentOfTotal: AnyView(Utils.getColorCodedTextView(totals.percentOfTotal, style: .percent).fontWeight(.bold)),
                percentProfit: AnyView(Utils.getColorCodedTextView(totals.percentProfit, style: .percent).fontWeight(.bold)),
                postMarketPrice: AnyView(Text("")),
                postMarketChangePercent: AnyView(Utils.getColorCodedTextView(totals.postMarketChangePercent, style: .percent).fontWeight(.bold)),
                postMarketChange: AnyView(Text("")),
                postMarketGain: AnyView(Utils.getColorCodedTextView(totals.postMarketGain, style: .decimal).fontWeight(.bold)),
                type: type
            )
            .environmentObject(appData)
    }
    
    func StockPriceGraph() -> some View {
        if type == .stock && chart.quotes.count > 0 {
            return AnyView (
                VStack {
                    Spacer()
                    LineView(data: chart.quotes.map { $0.close }, title: self.name, legend: "Year to Date").padding(10)
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var body: some View {
        
        let rowHeight: CGFloat = 36
        
        
        let stocks = getStocks(name: name, stockSortType: appData.stockSortType)
        
        
        ScrollView(.vertical) {
            ScrollViewReader { value in
                if ((horizontalSizeClass == .compact
                    && verticalSizeClass == .regular) ||
                    UIDevice.current.userInterfaceIdiom == .pad)
                    && !appData.showStocksForPortfolio
                    && self.type == StockTableType.account {
                    SummaryView(totals: getAccount())
                        .padding(.leading, 20)
                        .padding(.trailing, 0)
                }
                
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Text(type == .account ? "Stocks" : stocks.first?.name ?? name)
                        .fontWeight(.bold)
                        .font(type == .account ? .system(size:16) : .title)
                        .padding(EdgeInsets(top: 4, leading: ((type == .account) ? 30 : 20), bottom: 0, trailing: 0))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 0) {
                        VStack(spacing: 0) {
                            Text(type == .account ? "Name" : "Account").fontWeight(.bold)
                                .frame(width: ((type == .account) ? 120 : 160), alignment: .topLeading)
                                .frame(height: rowHeight)
                            
                            ForEach(stocks.indices, id: \.self) { i in
                                let stock = stocks[i]
                                let name = type == .stock ? stock.account : stock.ticker
                                VStack(alignment: .leading, spacing: 0) {
                                    
                                    Button(action: {
                                        let newType: StockTableType = (type == StockTableType.stock) ? StockTableType.account : StockTableType.stock
                                        
                                        print("tapped: \(name), stockType: \(newType)")
                                        self.chart = Chart()
                                        value.scrollTo(0)
                                        self.type = newType
                                        self.name = name
                                        appData.stockSortType = .ticker
                                        appData.stockSortDirection = .down
                                    }) {
                                        VStack (alignment: .leading) {
                                            Text(type == StockTableType.account ? (name == "SPAXX" ? "Cash" : name) : "")
                                                .lineLimit(1)
                                            Text(type == StockTableType.stock ? stock.account : (stock.name == "Cash") ? "Cash Account" : (stock.name ?? stock.ticker))
                                                .fontWeight(.regular).font(.system(size: (type == .account) ? 12 : 14))
                                                .lineLimit(1)
                                            
                                        }
                                    }
                                }
                                .id(i)
                                .frame(width: ((type == .account) ? 120 : 160), height: rowHeight, alignment: .topLeading)
                                .padding(.bottom, 8.275)

                            }
                            
                            Text("Total").fontWeight(.bold).font(.system(size: 14))
                                .frame(width: ((type == .account) ? 160 : 100), alignment: .leading)
                                .padding(.leading, (type == .account) ? 40 : -60)
                            
                        }
                        .padding(.leading, (type == .account) ? -10 : 20)
                        
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
                                                  percentOfTotalCost: AnyView(Utils.getColorCodedTextView(stock.percentOfTotalCost, style: .percent)),
                                                  profit: AnyView(Utils.getColorCodedTextView(stock.profit, style: .decimal)),
                                                  total: AnyView(Text(Utils.getFormattedNumber(stock.total))),
                                                  percentOfTotal: AnyView(Utils.getColorCodedTextView(stock.percentOfTotal, style: .percent)),
                                                  percentProfit: AnyView(Utils.getColorCodedTextView(stock.percentProfit, style: .percent)),
                                                  postMarketPrice: AnyView(Text(Utils.getFormattedNumber(stock.postMarketPrice))),
                                                  postMarketChangePercent: AnyView(Utils.getColorCodedTextView(stock.postMarketChangePercent, style: .percent)),
                                                  postMarketChange: AnyView(Utils.getColorCodedTextView(stock.postMarketChange, style: .decimal)),
                                                  postMarketGain: AnyView(Utils.getColorCodedTextView(stock.postMarketGain, style: .decimal)),
                                                  type: type
                                    )
                                    .environmentObject(appData)
                                    .frame(height: rowHeight)
                            }
                            getFooter(stocks: stocks)
                        }
                        }
                    }
                }
                StockPriceGraph().padding(EdgeInsets(top: 40, leading: 10, bottom: 0, trailing: 10))
            }
        }
        .padding(.leading, 0)
        .padding(.trailing, 20)
        .navigationTitle("\(getTitle())")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            print("StockTableView appearing for \(name)")
            getStockChartData()
        }
        
        
    }
}

struct StockTableView_Previews: PreviewProvider {
    
    @State static var portfolio = Api.getMockPortfolio()
    
    static var previews: some View {
        StockTableView(name: "Fidelity", type: .account)
    }
}
