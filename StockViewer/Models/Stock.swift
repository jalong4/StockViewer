//
//  Stock.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI

struct Stock: Codable, Identifiable {
    var id = UUID()
    var ticker = String()
    var name: String?
    var account = String()
    var quantity: Double = 0
    var price: Double = 0
    var priceChange: Double?
    var percentChange: Double = 0
    var dayGain: Double = 0
    var unitCost: Double = 0
    var totalCost: Double = 0
    var percentOfTotalCost: Double = 0
    var total: Double = 0
    var percentOfTotal: Double = 0
    var profit: Double = 0
    var percentProfit: Double = 0
    var previousClose: Double?
    var marketCapInBillions: Double = 0
    var fiftyTwoWeekLow: Double?
    var fiftyTwoWeekHigh: Double?
    var postMarketPrice: Double = 0
    var postMarketChangePercent: Double = 0
    var postMarketChange: Double = 0
    var postMarketGain: Double = 0
    
    private enum CodingKeys : String, CodingKey { case ticker, name, account, quantity, price, priceChange, percentChange, dayGain, unitCost, totalCost, percentOfTotalCost, total, percentOfTotal, profit, percentProfit, previousClose, marketCapInBillions, fiftyTwoWeekLow, fiftyTwoWeekHigh, postMarketPrice, postMarketChange, postMarketChangePercent, postMarketGain }
}
