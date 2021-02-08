//
//  SummaryView.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI

struct SummaryView: View {
    
    var totals: Account
    var title = "Holdings"
        
    var body: some View {
        ZStack {
            Color.white
            VStack(alignment: .leading) {
                
                HStack{
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                        Text(Utils.getFormattedNumber(totals.total))
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .padding(EdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0))
                        Text("Total Cost: " + Utils.getFormattedNumber(totals.totalCost))
                            .font(.system(size: 14))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                    }
                }
                StockGainsView(account: totals)
            }
            .font(.system(size: 14))
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    @State static var totals = Api.getMockPortfolio().summary.totals
    static var previews: some View {
        SummaryView(totals: totals, title: "My Portfolio")
    }
}
