//
//  CustomTextField.swift
//  StockViewer
//
//  Created by Jim Long on 2/14/21.
//

import SwiftUI

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String // String value of the TextView
    private var isSecure: Bool
    private var autocapitalization: UITextAutocapitalizationType
    let placeholder: String // Placeholder Text
    let keyboardType: UIKeyboardType // Keypad layout type
    let tag: Int // Tag to recognise each specific TextView
    let textAlignment: NSTextAlignment
    var commitHandler: (()->Void)? // Called when return key is pressed
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    
    init(_ placeholder: String,
         text: Binding<String>,
         isSecure: Bool = false,
         keyboardType: UIKeyboardType = .default,
         autocapitalization: UITextAutocapitalizationType = .none,
         textAlignment: NSTextAlignment = .left,
         tag: Int,
         onCommit: (()->Void)?) {
        
        self._text = text
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.tag = tag
        self.commitHandler = onCommit
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
        self.textAlignment = textAlignment
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {

        let textField = UITextField(frame: .zero)
        textField.keyboardType = self.keyboardType
        textField.textAlignment = self.textAlignment
        textField.delegate = context.coordinator
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .light)
        textField.isUserInteractionEnabled = true
        textField.autocapitalizationType = .none
        textField.text = text
        textField.isSecureTextEntry = self.isSecure
        textField.tag = tag
        textField.placeholder = placeholder
        textField.autocorrectionType = .no
        textField.autocapitalizationType = self.autocapitalization
        
        // For left inner padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
        textField.leftView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
        
        textField.rightView = paddingView
        textField.rightViewMode = UITextField.ViewMode.always
        
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = self.text
        uiView.setContentHuggingPriority(.init(rawValue: 70), for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    class Coordinator : NSObject, UITextFieldDelegate {
        
        var parent: CustomTextField
        
        init(_ uiTextView: CustomTextField) {
            self.parent = uiTextView
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            if let value = textField.text as NSString? {
                let proposedValue = value.replacingCharacters(in: range, with: string)
                parent.text = proposedValue as String
            }
            return true
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let nextTextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                nextTextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            return false
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.commitHandler?()
        }
    }
}
