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
    
    func getArray(slice: ArraySlice<StockGains>) -> [StockGains] {
        let result = Array(slice)
        return result
    }
    
    // navigation link for programmatic navigation
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
    
    // navigation link for programmatic navigation
    var navigationLinkProfile: NavigationLink<EmptyView, ProfileView>? {
        
        return NavigationLink(
            destination: ProfileView(),
            isActive: $appData.showingProfile
        ) {
            EmptyView()
        }
    }
    
    // navigation link for programmatic navigation
    var navigationLinkChangePassword: NavigationLink<EmptyView, ChangePasswordView>? {
        
        return NavigationLink(
            destination: ChangePasswordView(),
            isActive: $appData.showingChangePassword
        ) {
            EmptyView()
        }
    }
    
    // navigation link for programmatic navigation
    var navigationLinkEnterTrade: NavigationLink<EmptyView, EnterTradeView>? {
        
        return NavigationLink(
            destination: EnterTradeView(),
            isActive: $appData.showingEnterTrade
        ) {
            EmptyView()
        }
    }
    
    // navigation link for programmatic navigation
    var navigationLinkEditCash: NavigationLink<EmptyView, EditCashView>? {
        
        return NavigationLink(
            destination: EditCashView(),
            isActive: $appData.showingEditCash
        ) {
            EmptyView()
        }
    }
    
    // navigation link for programmatic navigation
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
        Api().getPortfolio { (portfolio) in
            appData.portfolio = portfolio
            self.appData.isDataLoading = false
        }
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
                                            self.selectedAccountName = "Portfolio"
                                            appData.stockSortType = .dayGain
                                            appData.stockSortDirection = .up
                                            appData.showStocksForPortfolio = true
                                            appData.showingStockTable = true
                                        }) {
                                            SummaryView(totals: appData.portfolio.summary.totals, title: "Portfolio")
                                                .padding([.leading, .trailing], 20)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        
                                    }
                                }
                            }
                            
                            navigationLinkProfile
                            navigationLinkChangePassword
                            navigationLinkStockTable
                            navigationLinkEnterTrade
                            navigationLinkEditCash
                            navigationLinkSettings
                            
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
