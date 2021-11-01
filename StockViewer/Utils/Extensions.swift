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

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }

    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
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
    
    @ViewBuilder
    func ifLet<V, Transform: View>(
        _ value: V?,
        transform: (Self, V) -> Transform
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}

extension Color {
    static let themeAccent = Color("AccentColor")
    static let themeAccentFaded = themeAccent.opacity(0.2)
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

extension String {
    func isValidEmail() -> Bool {

        
        if self.isEmpty {
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    
    func inValidEmailMessage() -> String {
        return self.isEmpty ? "Please enter an email address" : "Invalid Email address"
    }
    
    func isValidPassword() -> Bool {
        return !(self.isEmpty || self.count < 6)
    }
    
    func invalidPasswordMessage(fieldName: String = "password") -> String {
        return self.isEmpty ? "Please enter a " + fieldName : fieldName.capitalized + " must be at least 6 characters"
    }
    
    func upArrow() -> String {
        return "\u{2191}" + self
    }
    
    func downArrow() -> String {
        return "\u{2193}" + self
    }
    
    func sortPrefix(_ apply: Bool, _ direction: StockSortDirection) -> String {
        if !apply {
            return self
        }
        switch direction {
        case .up:
            return upArrow()
        case .down:
            return downArrow()
        }
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}



