//
//  Account.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import Foundation
import SwiftUI
import Combine

struct Account: Codable, Identifiable {
    var id = UUID()
    var name = String()
    var quantity: Double?
    var numStocks: Double = 0;
    var totalCost: Double = 0;
    var percentOfTotalCost: Double = 0;
    var total: Double = 0;
    var percentOfTotal: Double = 0;
    var dayGain: Double = 0;
    var percentChange: Double = 0;
    var profit: Double = 0;
    var percentProfit: Double = 0;
    var postMarketGain: Double = 0;
    var postMarketChangePercent: Double = 0;
    
    private enum CodingKeys : String, CodingKey { case name, numStocks, totalCost, total, dayGain, percentChange, profit, percentProfit, postMarketGain, postMarketChangePercent }
}
