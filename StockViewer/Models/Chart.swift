//
//  Quote.swift
//  StockViewer
//
//  Created by Jim Long on 2/14/21.
//

import SwiftUI

class Error : Codable {
    var msg = ""
}

class ChartResponse : Codable {
    var errors: [Error]?
    var chart: Chart?
}

class Chart: Codable {
    var ticker = ""
    var url: String = ""
    var numQuotes: Int = 0
    var avgPrice: Double = 0
    var quotes: [HistoricalQuote] = []
}

class HistoricalQuote: Codable {
    var epoch: Double = 0
    var date: String = ""
    var close: Double = 0
    var high: Double = 0
    var low: Double = 0
    var volume: Double = 0
}

extension HistoricalQuote: CustomStringConvertible {
    var description: String {
        let close = String(format: "%.2f", self.close)
        let low = String(format: "%.2f", self.low)
        let high = String(format: "%.2f", high)
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .decimal
        let volume = numberFormatter.string(from: NSNumber(value: volume))!
        return "\(date): close: \(close), [\(low) - \(high)], volume: \(volume)"
    }
}
