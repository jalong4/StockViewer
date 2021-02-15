//
//  PreviewTrade.swift
//  StockViewer
//
//  Created by Jim Long on 2/12/21.
//

import SwiftUI

struct PreviewTrade: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack() {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("OK")
                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                    .primaryButtonTextModifier()
            }
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
        }
    }
}

struct PreviewTrade_Previews: PreviewProvider {
    static var previews: some View {
        PreviewTrade()
    }
}
