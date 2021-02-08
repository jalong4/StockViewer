//
//  StockGainsView.swift
//  StockViewer
//
//  Created by Jim Long on 2/5/21.
//

import SwiftUI

struct StockGainsView: View {
    var account: Account
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Day Gain:")
                Text("Total Gain:")
                Group() {
                    if account.postMarketGain > 0 {
                        Text("Post Market:")
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(Utils.getFormattedGain(gain: account.dayGain, percent: account.percentChange))
                    .foregroundColor(Utils.getColor(account.dayGain))
                Text(Utils.getFormattedGain(gain: account.profit, percent: account.percentProfit))
                    .foregroundColor(Utils.getColor(account.profit))
                Group() {
                    if account.postMarketGain > 0 {
                        Text(Utils.getFormattedGain(gain: account.postMarketGain, percent: account.postMarketChangePercent))
                            .foregroundColor(Utils.getColor(account.postMarketGain))
                    }
                }
            }
        }.font(.system(size: 14)).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
    }
}

struct StockGainsView_Previews: PreviewProvider {
    @State static var account = Api.getMockPortfolio().summary.accounts[0]
    static var previews: some View {
        StockGainsView(account: account)
    }
}

