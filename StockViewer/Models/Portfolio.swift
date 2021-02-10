//
//  Portfolio.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI
import Combine

struct Portfolio : Codable {
    var summary = Summary();
    var stocks = [Stock]();
}

class PortfolioStore : ObservableObject {
    @Published var portfolio = Portfolio();
}

