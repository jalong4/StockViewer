//
//  TopMoversView.swift
//  StockViewer
//
//  Created by Jim Long on 2/6/21.
//

import SwiftUI

struct TopMoversView: View {
    var portfolio: Portfolio
    
    func getText(topMover: StockGains) -> String {
        var result = ""
        result = topMover.ticker;
        return result
    }
    
    var body: some View {
        HStack {
            LazyHStack(spacing: 20) {
                ForEach(portfolio.summary.topDayGainers, id: \.ticker) { topMover in
                    NavigationLink(destination: StockTableView(portfolio: portfolio, name: topMover.ticker, type: .stock)) {
                        VStack (alignment: .leading) {
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
                        .padding(2)
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct TopMoversView_Previews: PreviewProvider {
    @State static var portfolio = Api.getMockPortfolio()
    static var previews: some View {
        TopMoversView(portfolio: portfolio)
    }
}
