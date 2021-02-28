//
//  SvTextFieldNoTextMsg.swift
//  StockViewer
//
//  Created by Jim Long on 2/27/21.
//

import SwiftUI

//  Sv prefix signifies standardized for Stock Viewer design architecture

struct SvTextFieldNoTextMsg: View {
    
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
        
        CustomTextField(placeholder,
                        text: $text,
                        isSecure: isSecure,
                        keyboardType: keyboardType,
                        autocapitalization: autocapitalization,
                        textAlignment:  textAlignment,
                        tag: tag,
                        onCommit: nil)
            .frame(height: Constants.textFieldFrameHeight, alignment: .center)
            .background(Capsule().fill(Color.themeAccentFaded))
            .frame(maxWidth: Constants.textFieldMaxWidth)
            .padding([.top, .bottom], 0)
            .padding([.leading, .trailing], Constants.horizontalPadding)
            .onChange(of: text) { newValue in
                let result = validationCallback()
                if (!result.isValid) {
                    self.textMsg = result.errorMessage
                    self.isValid = false
                } else {
                    self.isValid = true
                    self.textMsg = ""
                }
                
                if let onChangeHandler = onChangeHandler {
                    onChangeHandler()
                }
            }
        
    }
}

struct SvTextFieldNoTextMsg_Previews: PreviewProvider {
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
