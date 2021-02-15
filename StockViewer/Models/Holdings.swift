//
//  Holdings.swift
//  StockViewer
//
//  Created by Jim Long on 2/13/21.
//

import SwiftUI


class HoldingsResponse : Codable {
    var summary: HoldingsSummary = HoldingsSummary()
    var holdings: [Holding] = []
}

class HoldingsSummary:  Codable {
    var found = 0
    var totalCost: Double = 0
}

class Holding:  Codable, Identifiable {
    
    var _id = String()
    var ticker = String()
    var quantity: Double = 0
    var totalCost: Double = 0
    var account = String()
    
    init(_id: String, ticker: String = String(), quantity: Double = 0, totalCost: Double = 0, account: String = String()) {
        self._id = _id
        self.ticker = ticker
        self.quantity = quantity
        self.totalCost = totalCost
        self.account = account
    }

}

class HoldingBody: Codable {
    var ticker = String()
    var quantity: Double = 0
    var totalCost: Double = 0
    var account = String()
    
    init(ticker: String = String(), quantity: Double = 0, totalCost: Double = 0, account: String = String()) {
        self.ticker = ticker
        self.quantity = quantity
        self.totalCost = totalCost
        self.account = account
    }
    
    init (holding: Holding) {
        self.ticker = holding.ticker
        self.quantity = holding.quantity
        self.totalCost = holding.totalCost
        self.account = holding.account
    }
}
