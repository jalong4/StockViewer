//
//  SizeClassView.swift
//  StockViewer
//
//  Created by Jim Long on 2/7/21.
//

import SwiftUI

struct SizeClassView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        
        if horizontalSizeClass == .compact && verticalSizeClass == .regular {
            
            Text("iPhone Portrait")
        }
        else if horizontalSizeClass == .regular && verticalSizeClass == .compact {
            
            Text("iPhone Landscape")
        }
        else if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            
            Text("iPad Portrait/Landscape")
        }
    }
}
