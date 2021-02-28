//
//  SvSecureTextField.swift
//  StockViewer
//
//  Created by Jim Long on 2/27/21.
//

import SwiftUI

//  Sv prefix signifies standardized for Stock Viewer design architecture

struct SvSecureTextField: View {
    
    private let placeholder: String // String value of the TextView
    @Binding var text: String // String value of the TextView
    let keyboardType: UIKeyboardType // Keypad layout type
    private var autocapitalization: UITextAutocapitalizationType
    let tag: Int // Tag to recognise each specific TextView
    let textAlignment: NSTextAlignment
    @Binding private var isValid: Bool
    var validationCallback: (()->ValidationResult)
    var onChangeHandler: (()->Void)?
    
    @State private var hideText: Bool = true
    
    @State private var textMsg = ""
    
    init(placeholder: String,
         text: Binding<String>,
         isValid: Binding<Bool>,
         keyboardType: UIKeyboardType = .default,
         autocapitalization: UITextAutocapitalizationType = .none,
         textAlignment: NSTextAlignment = .left,
         tag: Int,
         validationCallback: @escaping (()->ValidationResult),
         onChangeHandler: (()->Void)?) {
        
        self._text = text
        self.placeholder = placeholder
        self._isValid = isValid
        self.tag = tag
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
        self.textAlignment = textAlignment
        self.validationCallback = validationCallback
        self.onChangeHandler = onChangeHandler
    }
    
    
    var body: some View {
        
        ZStack {
            
            if hideText {
                SvTextFieldNoTextMsg(placeholder: placeholder,
                            text: $text,
                            isValid: $isValid,
                            isSecure: true,
                            tag: tag,
                            textMsg: $textMsg,
                            validationCallback: validationCallback,
                            onChangeHandler: onChangeHandler)
            } else {
                SvTextFieldNoTextMsg(placeholder: placeholder,
                            text: $text,
                            isValid: $isValid,
                            isSecure: false,
                            tag: tag,
                            textMsg: $textMsg,
                            validationCallback: validationCallback,
                            onChangeHandler: onChangeHandler)
            }
            
            HStack(spacing: 0) {
                Spacer()
                
                Button(action: {
                    print("Toggling hideText flag")
                    self.hideText.toggle()
                }) {
                    Image(systemName: hideText ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(Color.black.opacity(0.7))
                }
                .frame(maxWidth: 40, maxHeight: Constants.textFieldFrameHeight, alignment: .center)
                .mask(RoundedRectangle(cornerRadius: 90))
                .background(Color.themeAccent.opacity(0.01))
                
            }
            .padding([.leading, .trailing], Constants.horizontalPadding)
        }
        .padding(0)
        
        Text($textMsg.wrappedValue.isEmpty ? " " : $textMsg.wrappedValue)
            .frame(maxWidth: Constants.textFieldMaxWidth, alignment: .center)
            .padding(.top, 0)
            .padding(.bottom, 10)
            .foregroundColor(isValid ? Color.themeValid : Color.themeError)
    }
}

struct SvSecureTextField_Previews: PreviewProvider {
    static var previews: some View {
        SvSecureTextField(placeholder: "placeholder",
                          text: .constant(""),
                          isValid: .constant(false),
                          tag: 1,
                          validationCallback: { return ValidationResult(isValid: false,
                                                                        errorMessage: "Invalid text field") },
                          onChangeHandler: nil)
    }
}
