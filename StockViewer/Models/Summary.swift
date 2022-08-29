//
//  Summary.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI

struct Summary: Codable {
    var totals = Account()
    var accounts = [Account]()
    var topDayGainers: [StockGains]?
    var topDayLosers: [StockGains]?
    var mostProfitable: [StockGains]?
    var leastProfitable: [StockGains]?
}
