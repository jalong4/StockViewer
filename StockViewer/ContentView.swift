//
//  ContentView.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI

struct ContentView: View {
    @State var portfolio = Portfolio()
    @State var isDataLoading = true
        
    var body: some View {

        if self.isDataLoading {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    ProgressView("Loading...")
                        .scaleEffect(1.5, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: Utils.getGreenColor()))
                }
                .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                .foregroundColor(Utils.getGreenColor())
                .opacity(self.isDataLoading ? 1 : 0)
                .insetView()
            }
        }
        
        NavigationView{
            
            PortfolioSummary(portfolio: self.portfolio).padding(20)
                .onAppear {
                    Api().getPortfolio { (portfolio) in
                        self.portfolio = portfolio
                        self.isDataLoading = false;
                    }
                }
                .navigationTitle(Text(self.isDataLoading ? "" : "My Portfolio"))


        }
        .phoneOnlyStackNavigationView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
