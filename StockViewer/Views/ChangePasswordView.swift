//
//  ChangePasswordView.swift
//  StockViewer
//
//  Created by Jim Long on 2/8/21.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var oldPassword = ""
    @State private var password = ""
    @State private var password2 = ""
    
    @State private var hideOldPassword = true
    @State private var hidePassword = true
    @State private var hidePassword2 = true
    
    let horizontalPadding: CGFloat = 40
    let maxWidth: CGFloat = .infinity
    
    @State private var isUpdating: Bool = false
    @State private var disableUpdateButton: Bool = false

    @State private var oldPasswordMsg = ""
    @State private var passwordMsg = ""
    @State private var password2Msg = ""
    
    @State private var showAlert = false

    @State private var oldPasswordIsValid = false
    @State private var passwordIsValid = false
    @State private var password2IsValid = false
    
    @State private var user: User?
    
    
    var allFieldsValidated: Bool {
        return oldPasswordIsValid && passwordIsValid && password2IsValid
    }
    
    private func passwordView(_ label: String, textfield: Binding<String>, isSecure: Bool, tag: Int) -> CustomTextField {
        return CustomTextField(label, text: textfield, isSecure: isSecure, textAlignment: .left, tag: tag, onCommit: nil)
    }
    
    private func validateOldPw() {
        self.oldPasswordMsg = ""
        if (oldPassword.isEmpty || oldPassword.count < 6) {
            self.oldPasswordMsg = oldPassword.isEmpty ? "Enter your current password" : "Password must be at least 6 characters"
            self.oldPasswordIsValid = false
            self.disableUpdateButton = !allFieldsValidated
            return
        }
        self.oldPasswordIsValid = true
        self.disableUpdateButton = !allFieldsValidated
    }
    
    private func validatePw() {
        self.passwordMsg = ""
        if (password.isEmpty || password.count < 6) {
            self.passwordMsg = password.isEmpty ? "Enter a password" : "Password must be at least 6 characters"
            self.passwordIsValid = false
            self.disableUpdateButton = !allFieldsValidated
            return
        }
        self.passwordIsValid = true
        self.disableUpdateButton = !allFieldsValidated
    }
    
    private func validatePw2() {
        self.password2Msg = ""
        if (password2.isEmpty || (password2 != password)) {
            self.password2Msg = password2.isEmpty ? "Re-enter your password" : "Passwords don't match"
            self.password2IsValid = false
            self.disableUpdateButton = !allFieldsValidated
            return
        }
        self.password2IsValid = true
        self.disableUpdateButton = !allFieldsValidated
    }
    
    var body: some View {
        
        ZStack {
            Color.themeBackground
            
            VStack(alignment: .center, spacing: 0,  content: {
                    Text("")
                        .padding(.top, 180)
                    
                    SvSecureTextField(placeholder: "Old Password", text: $oldPassword, isValid: $oldPasswordIsValid,
                                      validationCallback: {
                                        return ValidationResult(
                                            isValid: oldPassword.isValidPassword(),
                                            errorMessage: oldPassword.invalidPasswordMessage(fieldName: "old Password")
                                        )},
                                      onChangeHandler: {
                                        self.disableUpdateButton = !allFieldsValidated
                                      }
                    )
                    
                SvSecureTextField(placeholder: "New Password", text: $password, isValid: $passwordIsValid,
                                      tag: 2,
                                      validationCallback: {
                                        return ValidationResult(
                                            isValid: password.isValidPassword(),
                                            errorMessage: password.invalidPasswordMessage()
                                        )},
                                      onChangeHandler: {
                                        // check if they now match and clear error if they do
                                        if (!password2IsValid) {
                                            if (password == password2) {
                                                password2IsValid.toggle()
                                            }
                                        }
                                        self.disableUpdateButton = !allFieldsValidated
                                      }
                    )
                    
                    SvSecureTextField(placeholder: "Confirm New Password", text: $password2, isValid: $password2IsValid,
                                      tag: 3,
                                      validationCallback: {
                                        return ValidationResult(
                                            isValid: password == password2,
                                            errorMessage: password2.isEmpty ? "Re-enter new password" : "Passwords don't match"
                                        )},
                                      onChangeHandler: {
                                        self.disableUpdateButton = !allFieldsValidated
                                      }
                    )
                    
                
                
                HStack (spacing: 20) {
                    Button(action: {
                        print("Updating")
                        if allFieldsValidated {
                            self.isUpdating = true
                            Api().changePassword(oldPassword: oldPassword, newPassword: password) { response in
                                print("Password Changed")
                                SettingsManager.sharedInstance.password = password
                                self.showAlert.toggle()
                            }

                        }
                    }) {
                        Text(isUpdating ? "Updating" : "Update")
                            .frame(minWidth: 100)
                            .padding()
                            .foregroundColor(Color.themeBackground)
                            .background(Capsule().fill(disableUpdateButton || isUpdating ? Color.themeAccentFaded : Color.themeAccent))
                    }
                    .disabled(disableUpdateButton || isUpdating)
                    .alert(isPresented: $showAlert, content: {
                        return Alert(title: Text("Password Updated"),
                                     message: nil,
                                     dismissButton: .default(Text("Ok"), action: {
                                        appState.showingChangePassword = false
                                        appState.showingStockTable = true
                                     }))
                    })
                    
                    Button(action: {
                        print("Canceling")
                        appState.showingChangePassword = false
                        appState.showingStockTable = true
                    }) {
                        Text("Cancel")
                            .frame(minWidth: 100)
                            .cancelButtonTextModifier()
                    }
                }
                .frame(maxWidth: maxWidth)
                .padding([.leading, .trailing], horizontalPadding)
                
                Spacer()
                
            })
        }
        .dismissKeyboardOnTap()
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            self.oldPassword = SettingsManager.sharedInstance.password ?? ""
            validateOldPw()
        }
    }
    
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
