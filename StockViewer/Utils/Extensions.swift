//
//  Extensions.swift
//  StockViewer
//
//  Created by Jim Long on 2/6/21.
//

import SwiftUI

extension Bundle {
    
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        print("Decoding data from Bundle \(file)")
        return Utils.decodeToObj(T.self, from: data, dateDecodingStrategy: dateDecodingStrategy, keyDecodingStrategy: keyDecodingStrategy);
    }
}

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}

extension Color {
    static let themeAccent = Color("AccentColor")
    static let themeBackground = Color("BackgroundColor")
    static let themeForeground = Color("ForegroundColor")
    static let themeBorder = Color("BorderColor")
    static let themeValid = Color("PositiveCurrencyColor")
    static let themeError = Color("NegativeCurrencyColor")
    static let themePositiveCurrency = Color("PositiveCurrencyColor")
    static let themeNegativeCurrency = Color("NegativeCurrencyColor")
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardOnTap())
    }
}

public struct DismissKeyboardOnTap: ViewModifier {
    public func body(content: Content) -> some View {
        #if os(macOS)
        return content
        #else
        return content.gesture(tapGesture)
        #endif
    }
    
    private var tapGesture: some Gesture {
        TapGesture().onEnded(endEditing)
    }
    
    private func endEditing() {
        UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .map {$0 as? UIWindowScene}
            .compactMap({$0})
            .first?.windows
            .filter {$0.isKeyWindow}
            .first?.endEditing(true)
    }
}



