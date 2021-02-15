//
//  ScrollToModel.swift
//  StockViewer
//
//  Created by Jim Long on 2/14/21.
//

import SwiftUI

class ScrollToModel: ObservableObject {
    enum Action {
        case end
        case top
    }
    @Published var direction: Action? = nil
}

