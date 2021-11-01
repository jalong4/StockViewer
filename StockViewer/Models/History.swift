//
//  History.swift
//  StockViewer
//
//  Created by Jim Long on 6/3/21.
//

import SwiftUI


struct History: Codable {
    var _id = String()
    var date = String()
    var data = Portfolio()
}

