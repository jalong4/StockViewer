//
//  StockTableRow.swift
//  StockViewer
//
//  Created by Jim Long on 2/6/21.
//

import SwiftUI

struct StockTableRow: View {
    var rowName: Text
    var price: Text
    var quantity: Text
    var percentChange: Text
    var priceChange: Text
    var dayGain: Text
    var unitCost: Text
    var totalCost: Text
    var profit: Text
    var total: Text
    var percentProfit: Text
    var ticker: Text
    var type = StockTableType.account
    
    var body: some View {
        HStack {
            rowName
                .frame(width: ((type == .account) ? 120 : 100), alignment: .leading)
                .layoutPriority(1)
            Group{
                
                price
                    .frame(width: 90, alignment: .trailing)
                
                quantity
                    .frame(width: 90, alignment: .trailing)
                
            }
            Group {
                percentChange
                    .frame(width: 70, alignment: .trailing)
                
                priceChange
                    .frame(width: 70, alignment: .trailing)
                
                dayGain
                    .frame(width: 90, alignment: .trailing)
            }
            
            Group {
                
                unitCost
                    .frame(width: 90, alignment: .trailing)
                
                totalCost
                    .frame(width: 90, alignment: .trailing)
            }
            Group {
                
                profit
                    .frame(width: 100, alignment: .trailing)
                
                total
                    .frame(width: 100, alignment: .trailing)
                
                percentProfit
                    .frame(width: 90, alignment: .trailing)
            }
            Group {
                ticker
                    .frame(width: 90, alignment: .trailing)
            }

        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 90, alignment: .topLeading)
    }
}

struct StockTableRow_Previews: PreviewProvider {
    static var previews: some View {
        StockTableRow(rowName: Text("Name").fontWeight(.bold),
                      price: Text("Price").fontWeight(.bold),
                      quantity: Text("Qty").fontWeight(.bold),
                      percentChange: Text("\u{0394}" + " (%)").fontWeight(.bold),
                      priceChange: Text("\u{0394}" + " ($)").fontWeight(.bold),
                      dayGain: Text("Day Gain").fontWeight(.bold),
                      unitCost: Text("Unit Cost").fontWeight(.bold),
                      totalCost: Text("Unit Cost").fontWeight(.bold),
                      profit: Text("Profit ($)").fontWeight(.bold),
                      total: Text("Total").fontWeight(.bold),
                      percentProfit: Text("Profit (%)").fontWeight(.bold),
                      ticker: Text("Ticker").fontWeight(.bold))
    }
}
