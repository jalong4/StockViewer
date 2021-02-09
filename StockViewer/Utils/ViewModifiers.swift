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

struct CardBorder: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 140, alignment: .topLeading)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.themeBorder, lineWidth: 1)
            )
    }
}

extension View {
    func cardBorder() -> some View {
        modifier( CardBorder() )
    }
}

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding()
            .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
    }
}

extension View {
    func textFieldModifier() -> some View {
        modifier( TextFieldModifier() )
    }
}

struct ButtondTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding()
            .foregroundColor(.white)
            .background(Capsule().fill(Color.themeAccent))
    }
}

extension View {
    func buttonTextModifier() -> some View {
        modifier( ButtondTextModifier() )
    }
}

