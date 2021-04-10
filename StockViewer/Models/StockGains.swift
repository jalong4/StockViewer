//
//  StockGains.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI

struct StockGains: Codable {
    var ticker = String()
    var shortName: String?
    var gain: Double = 0;
    var total: Double = 0;
    var percent: Double = 0;
}
