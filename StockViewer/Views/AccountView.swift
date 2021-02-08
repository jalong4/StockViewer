//
//  AccountView.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI

struct AccountView: View {
    var account: Account
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(account.name):")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 0))
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(Utils.getFormattedCurrency(account.total))
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 0))
                }
            }
            .font(.system(size: 14))
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
            StockGainsView(account: account)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    @State static var account = Account(name: "Fidelity", total: 1588776.78, dayGain: 13117.14, percentChange: 0.0083, profit: 1074939.12, percentProfit: 0.29585, postMarketGain: 2670.01, postMarketChangePercent: 0.0017)
    
    static var previews: some View {
        AccountView(account: account)
    }
}
