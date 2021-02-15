//
//  CustomTextField.swift
//  StockViewer
//
//  Created by Jim Long on 2/14/21.
//

import SwiftUI

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String // String value of the TextView
    let placeholder: String // Placeholder Text
    let keyboardType: UIKeyboardType // Keypad layout type
    let tag: Int // Tag to recognise each specific TextView
    var commitHandler: (()->Void)? // Called when return key is pressed
    
    init(_ placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType, tag: Int, onCommit: (()->Void)?) {
        self._text = text
        self.placeholder = placeholder
        self.tag = tag
        self.commitHandler = onCommit
        self.keyboardType = keyboardType
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        // Customise the TextField as you wish
        let textField = UITextField(frame: .zero)
        textField.keyboardType = self.keyboardType
        textField.delegate = context.coordinator
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .light)
        textField.isUserInteractionEnabled = true
        textField.text = text
        textField.tag = tag
        textField.placeholder = placeholder
        textField.autocorrectionType = .no
        
        // For left inner padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 120))
        textField.leftView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
        
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
