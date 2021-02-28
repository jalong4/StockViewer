//
//  SvTextField.swift
//  StockViewer
//
//  Created by Jim Long on 2/27/21.
//

import SwiftUI

//  Sv prefix signifies standardized for Stock Viewer design architecture

struct SvTextField: View {
    
    private let placeholder: String // String value of the TextView
    @Binding var text: String // String value of the TextView
    private var isSecure: Bool
    let keyboardType: UIKeyboardType // Keypad layout type
    private var autocapitalization: UITextAutocapitalizationType
    let tag: Int // Tag to recognise each specific TextView
    let textAlignment: NSTextAlignment
    @Binding private var isValid: Bool
    @Binding var textMsg: String
    var validationCallback: (()->ValidationResult)
    var onChangeHandler: (()->Void)?


    init(placeholder: String,
         text: Binding<String>,
         isValid: Binding<Bool>,
         isSecure: Bool = false,
         keyboardType: UIKeyboardType = .default,
         autocapitalization: UITextAutocapitalizationType = .none,
         textAlignment: NSTextAlignment = .left,
         tag: Int = 1,
         textMsg: Binding<String> = .constant(""),
         validationCallback: @escaping (()-> ValidationResult),
         onChangeHandler: (()->Void)?) {
        
        self._text = text
        self._textMsg = textMsg
        self.placeholder = placeholder
        self._isValid = isValid
        self.isSecure = isSecure
        self.tag = tag
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
        self.textAlignment = textAlignment
        self.validationCallback = validationCallback
        self.onChangeHandler = onChangeHandler
    }
    
    
    var body: some View {
        
        SvTextFieldNoTextMsg(placeholder: placeholder,
                             text: $text,
                             isValid: $isValid,
                             isSecure: isSecure,
                             tag: tag,
                             textMsg: $textMsg,
                             validationCallback: validationCallback,
                             onChangeHandler: onChangeHandler)

        
        Text($textMsg.wrappedValue.isEmpty ? " " : $textMsg.wrappedValue)
            .frame(maxWidth: Constants.textFieldMaxWidth, alignment: .center)
            .padding(.top, 0)
            .padding(.bottom, 10)
            .foregroundColor(isValid ? Color.themeValid : Color.themeError)
        
    }
}

struct SvTextField_Previews: PreviewProvider {
    static var previews: some View {
        SvTextField(placeholder: "placeholder",
                    text: .constant(""),
                    isValid: .constant(false),
                    isSecure: false,
                    tag: 1,
                    textMsg: .constant("Invalid text field"),
                    validationCallback: { return ValidationResult(isValid: false,
                                                                  errorMessage: "Invalid text field") },
                    onChangeHandler: nil)
    }
}
