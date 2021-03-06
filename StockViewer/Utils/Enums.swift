//
//  Enums.swift
//  StockViewer
//
//  Created by Jim Long on 2/6/21.
//

import Foundation

enum StockTableType {
    case stock, account
}

enum StockSortType {
    case name, ticker, percentChange, priceChange, dayGain, totalCost, percentOfTotalCost, profit, total, percentOfTotal, percentProfit, postMarketChangePercent, postMarketChange, postMarketGain
}

enum StockSortDirection {
    case up, down
}
