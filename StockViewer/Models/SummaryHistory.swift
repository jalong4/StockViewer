//
//  SummaryHistory.swift
//  StockViewer
//
//  Created by Jim Long on 8/28/22.
//

import SwiftUI

struct SummaryHistory: Codable {
    var _id = String()
    var date = String()
    var summary = Summary()
}
