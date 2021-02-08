//
//  ViewModifiers.swift
//  StockViewer
//
//  Created by Jim Long on 2/6/21.
//

import SwiftUI

struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarHidden(true)
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}

struct InsetViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            VStack {
                content
                    .frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.8, alignment: .center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

extension View {
    func insetView() -> some View {
        modifier( InsetViewModifier() )
    }
}
