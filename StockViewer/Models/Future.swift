//
//  Future.swift
//  StockViewer
//
//  Created by Jim Long on 2/13/21.
//

import SwiftUI
import Combine


class FutureResponse : Codable {
    var count: Int
    var futures: [Future] = []
}

class Futures: ObservableObject {
    @Published var list = [Future]()
}

class Future:  ObservableObject, Codable, Identifiable {
    
    enum CodingKeys: CodingKey {
        case _id, ticker, price, active
    }
    
    var _id = String()
    @Published var ticker = String()
    @Published var price: Double = 0
    @Published var active: Bool = true
    
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _id = try container.decode(String.self, forKey: ._id)
        ticker = try container.decode(String.self, forKey: .ticker)
        price = try container.decode(Double.self, forKey: .price)
        active = try container.decode(Bool.self, forKey: .active)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(ticker, forKey: .ticker)
        try container.encode(price, forKey: .price)
        try container.encode(active, forKey: .active)
    }
}

class FutureBody: Codable {
    var ticker = String()
    var price: Double = 0
    var active: Bool
    
    init (future: Future) {
        self.ticker = future.ticker
        self.price = future.price
        self.active = future.active
    }
    
    init(ticker: String = String(),
         price: Double = 0,
         active: Bool = true) {
        
        self.ticker = ticker
        self.price = price
        self.active = active
    }
}
