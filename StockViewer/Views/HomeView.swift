//
//  HomeView.swift
//  StockViewer
//
//  Created by Jim Long on 2/9/21.
//

import SwiftUI

struct HomeView: View {
    
    @State var portfolio: Portfolio
    
    @EnvironmentObject var appState: AppState
    
    func NagivateToView() -> AnyView {
        switch appState.navigateTo {
        case .Profile:
            return AnyView(ProfileView())
        case .EnterTrade:
            return AnyView(EnterTradeView(portfolio: portfolio))
        case .EditCash:
            return AnyView(EditCashView(portfolio: portfolio))
        case .Settings:
            return AnyView(SettingsView())
        default:
            return AnyView(Text(""))
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
                
                if appState.navigateTo != .Home {
                    NagivateToView()
                } else if !appState.isDataLoading {
                    NavigationView{
                        PortfolioSummary(portfolio: self.portfolio)
                            .padding(20)
                            .navigationTitle(Text(appState.isDataLoading ? "" : "My Portfolio"))
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
                                                            appState.refreshingData = true
                                                            print("Refreshing data")
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
    }
    
}

struct HomeView_Previews: PreviewProvider {
    @State static var portfolio = Api.getMockPortfolio();
    static var previews: some View {
        HomeView(portfolio: portfolio)
    }
}
