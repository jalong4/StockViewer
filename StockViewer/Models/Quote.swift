//
//  Quote.swift
//  StockViewer
//
//  Created by Jim Long on 2/14/21.
//

import SwiftUI

class QuoteResponse : Codable {
    var result: [Quote]?
}

class Quote: Codable {
    var symbol = ""
    var shortName: String?
    var displayName: String?
    var longName: String?
    var regularMarketPrice: Double = 0
    var regularMarketChange: Double = 0
}
