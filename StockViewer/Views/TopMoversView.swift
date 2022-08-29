//
//  TopMoversView.swift
//  StockViewer
//
//  Created by Jim Long on 2/6/21.
//

import SwiftUI

struct TopMoversView: View {
    @EnvironmentObject var appData: AppData
    var title: String
    var stockGains: [StockGains]
    
    var body: some View {
        VStack {
            Text(stockGains.count > 0 ? title : "")
                .font(.system(size: 14))
                .fontWeight(.bold)
            HStack {
                
                ForEach (0 ..< 4) { index in
                    if index < stockGains.count {
                    let topMover = stockGains[index]
                        NavigationLink(destination: StockTableView(appData: _appData, name: topMover.ticker, type: .stock)) {
                            VStack (alignment: .center) {
                                Text("\(topMover.ticker)").fontWeight(.bold)
                                Text(Utils.getFormattedCurrency(topMover.gain, fractionDigits: 0)).fontWeight(.bold)
                                Text(Utils.getFormattedPercent(topMover.percent))
                                    .fontWeight(.bold)
                                    .padding(EdgeInsets(top: 2, leading: 4, bottom: 4, trailing: 4))
                                    .background(Utils.getColor(topMover.gain))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                            }
                            .font(.system(size: 12))
                            .padding(1)
                            .frame(minWidth: 0, maxWidth: .infinity)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

struct TopMoversView_Previews: PreviewProvider {
    @State static var portfolio = Api.getMockPortfolio()
    static var previews: some View {
        TopMoversView(title: "Top Gainers", stockGains: portfolio.summary.topDayGainers ?? [])
    }
}
