//
//  HomeView.swift
//  StockViewer
//
//  Created by Jim Long on 2/9/21.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @EnvironmentObject var appData: AppData
    
    
    @State private var selectedAccountName: String?
    @State private var showingSheet: Bool = false
    @State private var date = Date()
    @State private var dateRange: ClosedRange<Date>? = nil
    
    func getArray(slice: ArraySlice<StockGains>) -> [StockGains] {
        let result = Array(slice)
        return result
    }
    
    var navigationLinkStockTable: NavigationLink<EmptyView, StockTableView>? {
        guard let selectedAccountName = selectedAccountName else {
            return nil
        }
        
        return NavigationLink(
            destination: StockTableView(appData: _appData, name: selectedAccountName, type: .account),
            isActive: $appData.showingStockTable
        ) {
            EmptyView()
        }
    }
    
    var navigationLinkProfile: NavigationLink<EmptyView, ProfileView>? {
        
        return NavigationLink(
            destination: ProfileView(),
            isActive: $appData.showingProfile
        ) {
            EmptyView()
        }
    }
    
    var navigationLinkChangePassword: NavigationLink<EmptyView, ChangePasswordView>? {
        
        return NavigationLink(
            destination: ChangePasswordView(),
            isActive: $appData.showingChangePassword
        ) {
            EmptyView()
        }
    }
    
    var navigationLinkEnterTrade: NavigationLink<EmptyView, EnterTradeView>? {
        
        return NavigationLink(
            destination: EnterTradeView(),
            isActive: $appData.showingEnterTrade
        ) {
            EmptyView()
        }
    }
    
    var navigationLinkEditCash: NavigationLink<EmptyView, EditCashView>? {
        
        return NavigationLink(
            destination: EditCashView(),
            isActive: $appData.showingEditCash
        ) {
            EmptyView()
        }
    }
    
    var navigationLinkBalanceHistory: NavigationLink<EmptyView, BalanceHistoryView>? {
        
        return NavigationLink(
            destination: BalanceHistoryView(),
            isActive: $appData.showingBalanceHistory
        ) {
            EmptyView()
        }
    }
    
    var navigationLinkFuture: NavigationLink<EmptyView, FuturesView>? {
        
        return NavigationLink(
            destination: FuturesView(),
            isActive: $appData.showingFutures
        ) {
            EmptyView()
        }
    }
    
    var navigationLinkSettings: NavigationLink<EmptyView, SettingsView>? {
        
        return NavigationLink(
            destination: SettingsView(),
            isActive: $appData.showingSettings
        ) {
            EmptyView()
        }
    }
    
    private func loadData() {
        appData.isDataLoading = true
        self.date = Date()
        
        appData.isNetworkReachable = NetworkReachability().reachable
        if appData.isNetworkReachable {
            appData.isDataLoading = true
            Api().getPortfolio { (portfolio) in
                appData.portfolio = portfolio
                self.appData.isDataLoading = false
            }
        }
        
        getBalanceHistory()
    }
    
    private func toDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
    
    private func toDateString(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    private func getBalanceHistory() {
        
        Api().getStocksBackup(completion: { history in
            guard let history = history else {
                print("No balance history found")
                return
            }
            
                appData.history = history
                appData.dates = history.map { toDate(dateString: $0.date) ?? Date() }
                print("Found \(history.count) balance history entry" + (history.count == 1 ? "y" : "ies"))

        })
    }
    
    private func getPortfolio(for date: Date) -> Portfolio {
        guard let dateString = toDateString(date: date) else {
            return appData.portfolio
        }
        
        let history = appData.history.filter { $0.date == dateString }.first
        return history?.data ?? appData.portfolio

    }
    
    private var calendarButton: some View {
        
        if appData.dates.count == 0 {
            return AnyView(EmptyView())
        }
        
        let min = appData.dates.reduce(appData.dates[0]){$0 > $1 ? $1 : $0}
        let max = appData.dates.reduce(appData.dates[0]){$0 < $1 ? $1 : $0}
        
        return AnyView(
            Button(action: {
                self.showingSheet.toggle()
                
            }) {
                Image(systemName: "calendar")
                
            }
            .sheet(isPresented: self.$showingSheet, onDismiss: {
                // do stuff with date
            }, content: {
                Text("Portfolio Date: " + (toDateString(date: date) ?? "Unknown")).font(.title)
                DatePicker("Portfolio Date", selection: $date, in: min...max, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
                    .frame(maxHeight: 400)
                    .padding()
                    .onChange(of: date, perform: { (value) in
                        appData.portfolio = getPortfolio(for: date)
                    })
                Button(action: {
                    print("Ok tapped")
                    self.showingSheet.toggle()
                }) {
                    Text("Ok")
                        .frame(minWidth: 100)
                        .padding()
                        .foregroundColor(Color.themeBackground)
                        .background(Capsule().fill(Color.themeAccent.opacity(1.0)))
                }
            })
        )
    }
    
    
    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            let drag = DragGesture(minimumDistance: 30, coordinateSpace: .local)
                .onEnded {
                    if $0.translation.width < -100 {
                        withAnimation {
                            appData.showMenu = false
                        }
                    }
                }
            
            ZStack {
                Color.themeBackground
                    .edgesIgnoringSafeArea(.all
                    )
                
                NavigationView {
                    
                    VStack {
                        if !appData.isDataLoading {
                            HStack {
                                Text("Date: " + (toDateString(date: date) ?? "yyyy-mm-dd"))
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .padding([.leading, .trailing], 20)
                                Spacer()
                            }
                            TabView {
                                TopMoversView(title: "Top Gainers", stockGains:Array(appData.portfolio.summary.topDayGainers))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                
                                TopMoversView(title: "Top Losers", stockGains:Array(appData.portfolio.summary.topDayLosers))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                
                                TopMoversView(title: "Most Profitable", stockGains:Array(appData.portfolio.summary.mostProfitable))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                
                                TopMoversView(title: "Least Profitable", stockGains:Array(appData.portfolio.summary.leastProfitable))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                
                            }
                            .padding(0)
                            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 90)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            
                            if (horizontalSizeClass == .compact && verticalSizeClass == .regular)
                                ||  UIDevice.current.userInterfaceIdiom == .pad {
                                if let totals = appData.portfolio.summary.totals {
                                    if totals.total > 0 {
                                        Button(action: {
                                            print("Portfolio tapped")
                                            self.selectedAccountName = "Portfolio: " + (toDateString(date: date) ?? "Unknown")
                                            appData.stockSortType = .dayGain
                                            appData.stockSortDirection = .up
                                            appData.showStocksForPortfolio = true
                                            appData.showingStockTable = true
                                        }) {
                                            SummaryView(totals: appData.portfolio.summary.totals, title: "Portfolio: " + (toDateString(date: date) ?? "Unknown"))
                                                .padding([.leading, .trailing], 20)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        
                                    }
                                }
                            }
                            
                            Group {
                                navigationLinkProfile
                                navigationLinkChangePassword
                                navigationLinkStockTable
                                navigationLinkEnterTrade
                                navigationLinkEditCash
                                navigationLinkBalanceHistory
                                navigationLinkFuture
                                navigationLinkSettings
                            }
                            
                            ScrollView(showsIndicators: false) {
                                LazyVStack {
                                    ForEach(appData.portfolio.summary.accounts) { account in
                                        Button(action: {
                                            self.selectedAccountName = account.name
                                            appData.stockSortType = .ticker
                                            appData.showStocksForPortfolio = false
                                            appData.showingStockTable = true
                                        }) {
                                            AccountView(account: account)
                                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                                                .cardBorder()
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                
                            }
                            .padding([.leading, .trailing], 20)
                            .padding(.top, 8)
                            .navigationTitle(Text(appData.isDataLoading ? "" : "Portfolio"))
                            .navigationBarItems(leading:
                                                    Button(action: {
                                                        withAnimation {
                                                            appData.showMenu.toggle()
                                                        }
                                                        
                                                    }) {
                                                        if !appData.isDataLoading {
                                                            Image(systemName: "line.horizontal.3")
                                                                .imageScale(.large)
                                                                .padding()
                                                                .foregroundColor(Color.themeAccent)
                                                        }
                                                    }, trailing:
                                                        HStack (spacing: 20) {
                                                            calendarButton.disabled(appData.dates.count == 0)
                                                            
                                                            Button(action: {
                                                                print("Refreshing data")
                                                                self.loadData()
                                                                
                                                            }) {
                                                                if !appData.isDataLoading {
                                                                    Image(systemName: "arrow.clockwise"
                                                                    )
                                                                    .imageScale(.large)
                                                                    .padding()
                                                                    .foregroundColor(Color.themeAccent)
                                                                }
                                                            }
                                                        }
                            )
                        }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .offset(x: appData.showMenu ? geometry.size.width/2 : 0)
            .disabled(appData.showMenu ? true : false)
            .transition(.move(edge: .leading))
            .gesture(drag)
            
            if appData.showMenu {
                MenuView()
                    .frame(width: geometry.size.width/2)
            }
        }
        .onAppear {
            // if in split view, programatically navigate to first account
            
            let size = UIScreen.main.bounds.size
            let isLandscape = size.width > size.height
            appData.showingStockTable = false
            
            if appData.needsRefreshData {
                appData.needsRefreshData.toggle()
                print("Refreshing data")
                self.loadData()
            }
            
            print("isLandscape: \(isLandscape)")
//            if (UIDevice.current.userInterfaceIdiom == .pad) { // && isLandscape {
//                appData.stockSortType = .ticker
//                appData.showingStockTable = true
//                self.selectedAccountName = self.portfolio.summary.accounts.first?.name
//            }
            
        }
    }
    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
