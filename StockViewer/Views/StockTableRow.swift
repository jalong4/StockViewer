//
//  StockTableRow.swift
//  StockViewer
//
//  Created by Jim Long on 2/6/21.
//

import SwiftUI

struct StockTableRow: View {
    @EnvironmentObject var appState: AppState
    
    var price: AnyView
    var quantity: AnyView
    var percentChange: AnyView
    var priceChange: AnyView
    var dayGain: AnyView
    var unitCost: AnyView
    var totalCost: AnyView
    var profit: AnyView
    var total: AnyView
    var percentProfit: AnyView
    var postMarketPrice: AnyView
    var postMarketChangePercent: AnyView
    var postMarketChange: AnyView
    var postMarketGain: AnyView
    var type = StockTableType.account
    
    var body: some View {
        HStack {
            Group{
                price
                    .frame(width: 90, alignment: .topTrailing)
                quantity
                    .frame(width: 90, alignment: .topTrailing)
                percentChange
                    .frame(width: 70, alignment: .topTrailing)

                
                priceChange
                    .frame(width: 70, alignment: .topTrailing)
                
                dayGain
                    .frame(width: 90, alignment: .topTrailing)
            }
            
            Group {
                
                unitCost
                    .frame(width: 90, alignment: .topTrailing)
                
                totalCost
                    .frame(width: 90, alignment: .topTrailing)

                profit
                    .frame(width: 100, alignment: .topTrailing)
                
                total
                    .frame(width: 100, alignment: .topTrailing)
                
                percentProfit
                    .frame(width: 90, alignment: .topTrailing)
            }
            
            if appState.postMarketDataIsAvailable {
                Group {

                    postMarketPrice
                        .frame(width: 100, alignment: .topTrailing)
                    
                    postMarketChangePercent
                        .frame(width: 100, alignment: .topTrailing)
                    
                    postMarketChange
                        .frame(width: 90, alignment: .topTrailing)
                    
                    
                    postMarketGain
                        .frame(width: 90, alignment: .topTrailing)
                }
            }

        }
    }
}

struct StockTableRow_Previews: PreviewProvider {
    static var previews: some View {
        StockTableRow(price: AnyView(Text("Price").fontWeight(.bold)),
                      quantity: AnyView(Text("Qty").fontWeight(.bold)),
                      percentChange: AnyView(Text("\u{0394}" + " (%)").fontWeight(.bold)),
                      priceChange: AnyView(Text("\u{0394}" + " ($)").fontWeight(.bold)),
                      dayGain: AnyView(Text("Day Gain").fontWeight(.bold)),
                      unitCost: AnyView(Text("Unit Cost").fontWeight(.bold)),
                      totalCost: AnyView(Text("Unit Cost").fontWeight(.bold)),
                      profit: AnyView(Text("Profit ($)").fontWeight(.bold)),
                      total: AnyView(Text("Total").fontWeight(.bold)),
                      percentProfit: AnyView(Text("Profit (%)").fontWeight(.bold)),
                      postMarketPrice: AnyView(Text("Post Price").fontWeight(.bold)),
                      postMarketChangePercent: AnyView(Text("Post " + "\u{0394}" + " (%)").fontWeight(.bold)),
                      postMarketChange: AnyView(Text("Post " + "\u{0394}" + " ($)").fontWeight(.bold)),
                      postMarketGain: AnyView(Text("Post Gain").fontWeight(.bold))
        )
    }
}
