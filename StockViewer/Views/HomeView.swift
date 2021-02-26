//
//  HomeView.swift
//  StockViewer
//
//  Created by Jim Long on 2/9/21.
//

import SwiftUI

struct HomeView: View {
    
    @State var portfolio: Portfolio
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @EnvironmentObject var appState: AppState
    
    
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
            destination: StockTableView(appState: _appState, portfolio: self.portfolio, name: selectedAccountName, type: .account),
            isActive: $appState.showingStockTable
        ) {
            EmptyView()
        }
    }
    
    // navigation link for programmatic navigation
    var navigationLinkProfile: NavigationLink<EmptyView, ProfileView>? {
        
        return NavigationLink(
            destination: ProfileView(),
            isActive: $appState.showingProfile
        ) {
            EmptyView()
        }
    }
    
    // navigation link for programmatic navigation
    var navigationLinkChangePassword: NavigationLink<EmptyView, ChangePasswordView>? {
        
        return NavigationLink(
            destination: ChangePasswordView(),
            isActive: $appState.showingChangePassword
        ) {
            EmptyView()
        }
    }
    
    // navigation link for programmatic navigation
    var navigationLinkEnterTrade: NavigationLink<EmptyView, EnterTradeView>? {
        
        return NavigationLink(
            destination: EnterTradeView(portfolio: portfolio),
            isActive: $appState.showingEnterTrade
        ) {
            EmptyView()
        }
    }
    
    // navigation link for programmatic navigation
    var navigationLinkEditCash: NavigationLink<EmptyView, EditCashView>? {
        
        return NavigationLink(
            destination: EditCashView(portfolio: portfolio),
            isActive: $appState.showingEditCash
        ) {
            EmptyView()
        }
    }
    
    // navigation link for programmatic navigation
    var navigationLinkSettings: NavigationLink<EmptyView, SettingsView>? {
        
        return NavigationLink(
            destination: SettingsView(),
            isActive: $appState.showingSettings
        ) {
            EmptyView()
        }
    }
    
    private func loadData() {
        appState.isDataLoading = true
        Api().getPortfolio { (portfolio) in
            self.portfolio = portfolio
            self.appState.isDataLoading = false
        }
    }
    
    
    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            let drag = DragGesture(minimumDistance: 30, coordinateSpace: .local)
                .onEnded {
                    if $0.translation.width < -100 {
                        withAnimation {
                            appState.showMenu = false
                        }
                    }
                }
            
            ZStack {
                Color.themeBackground
                    .edgesIgnoringSafeArea(.all
                    )
                
                NavigationView {
                    
                    VStack {
                        if !appState.isDataLoading {
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
                                            .padding([.leading, .trailing], 20)
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
                                    ForEach(self.portfolio.summary.accounts) { account in
                                        Button(action: {
                                            self.selectedAccountName = account.name
                                            appState.showingStockTable = true
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
                            .navigationTitle(Text(appState.isDataLoading ? "" : "Portfolio"))
                            .navigationBarItems(leading:
                                                    Button(action: {
                                                        withAnimation {
                                                            appState.showMenu.toggle()
                                                        }
                                                        
                                                    }) {
                                                        if !appState.isDataLoading {
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
                                                            if !appState.isDataLoading {
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
            .offset(x: appState.showMenu ? geometry.size.width/2 : 0)
            .disabled(appState.showMenu ? true : false)
            .transition(.move(edge: .leading))
            .gesture(drag)
            
            if appState.showMenu {
                MenuView()
                    .frame(width: geometry.size.width/2)
            }
        }
        .onAppear {
            // if in split view, programatically navigate to first account
            
            let size = UIScreen.main.bounds.size
            let isLandscape = size.width > size.height
            appState.showingStockTable = false
            
            print("isLandscape: \(isLandscape)")
            if (UIDevice.current.userInterfaceIdiom == .pad) { // && isLandscape {
                appState.stockSortType = .ticker
                appState.showingStockTable = true
                self.selectedAccountName = self.portfolio.summary.accounts.first?.name
            }
            
        }
    }
    
}


struct HomeView_Previews: PreviewProvider {
    @State static var portfolio = Api.getMockPortfolio();
    static var previews: some View {
        HomeView(portfolio: portfolio)
    }
}
