//
//  HomeView.swift
//  StockViewer
//
//  Created by Jim Long on 2/9/21.
//

import SwiftUI

struct HomeView: View {
    
    @State var portfolio = Portfolio()
    @State var isDataLoading = true
    @State var showMenu = false
    
    private func loadData() {
        self.isDataLoading = true
        self.portfolio = Portfolio()
        Api().getPortfolio { (portfolio) in
            self.portfolio = portfolio
            self.isDataLoading = false;
        }
    }
    
    var body: some View {
        
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }
        
        if self.isDataLoading {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    ProgressView("Loading...")
                        .scaleEffect(1.5, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.themeAccent))
                }
                .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                .foregroundColor(Color.themeAccent)
                .opacity(self.isDataLoading ? 1 : 0)
                .insetView()
            }
        }
        
        
        GeometryReader { geometry in
            
            
            
            NavigationView{
                

                PortfolioSummary(portfolio: self.portfolio).padding(20)
                    .navigationTitle(Text(self.isDataLoading ? "" : "My Portfolio"))
                    .navigationBarItems(leading:
                                            Button(action: {
                                                withAnimation {
                                                    self.showMenu.toggle()
                                                    //                                                AuthUtils().logOut()
                                                }
                                                
                                            }) {
                                                if !isDataLoading {
                                                    Image(systemName: "line.horizontal.3")
                                                        .imageScale(.large)
                                                        .padding()
                                                        .foregroundColor(Color.themeAccent)
                                                }
                                            }, trailing:
                                                Button(action: {
                                                    self.isDataLoading = true
                                                    print("Refreshing data")
                                                    self.loadData()
                                                }) {
                                                    if !isDataLoading {
                                                        Image(systemName: "arrow.clockwise"
                                                        )
                                                        .imageScale(.large)
                                                        .padding()
                                                        .foregroundColor(Color.themeAccent)
                                                    }
                                                }
                    )
            }
            .onAppear {
                loadData()
            }
            .phoneOnlyStackNavigationView()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .offset(x: self.showMenu ? geometry.size.width/2 : 0)
            .disabled(self.showMenu ? true : false)
            .transition(.move(edge: .leading))

            
            if self.showMenu {
                MenuView(showMenu: self.$showMenu)
                    .frame(width: geometry.size.width/2)
            }
            
        }.gesture(drag)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
