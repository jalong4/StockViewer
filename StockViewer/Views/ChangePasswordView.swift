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

    @State private var oldPassword = "123456"
    @State private var password = "123456"
    @State private var password2 = "123456"
    
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
                
                ZStack {
                    
                    if hideOldPassword {
                        passwordView("Old Password", textfield: $oldPassword, isSecure: true, tag: 1)
                            .frame(height: 40, alignment: .center)
                            .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                            .frame(maxWidth: maxWidth)
                            .padding([.top, .bottom], 4)
                            .padding([.leading, .trailing], horizontalPadding)
                            .onChange(of: oldPassword) { newValue in
                                validateOldPw()
                            }
                    } else {
                        passwordView("Old Password", textfield: $oldPassword, isSecure: false, tag: 1)
                            .frame(height: 40, alignment: .center)
                            .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                            .frame(maxWidth: maxWidth)
                            .padding([.top, .bottom], 4)
                            .padding([.leading, .trailing], horizontalPadding)
                            .onChange(of: oldPassword) { newValue in
                                validateOldPw()
                            }
                    }
                    HStack(spacing: 0) {
                        Spacer()
                        
                        Button(action: {
                            print("Toggling hide Oldpassword flag")
                            self.hideOldPassword.toggle()
                        }) {
                            Image(systemName: hideOldPassword ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(Color.black.opacity(0.7))
                        }
                        .frame(maxWidth: 40, maxHeight: 40, alignment: .center)
                        .mask(RoundedRectangle(cornerRadius: 90))
                        .background(Color.themeAccent.opacity(0.01))
                        
                    }
                    .padding([.leading, .trailing],horizontalPadding)
                }
                .padding(0)
                .padding(.top, 180)
                
                Text($oldPasswordMsg.wrappedValue)
                    .frame(maxWidth: maxWidth, alignment: .center)
                    .padding(.bottom, 4)
                    .foregroundColor(oldPasswordIsValid ? Color.themeValid : Color.themeError)
                    
                    ZStack {
                        
                        if hidePassword {
                            passwordView("New Password", textfield: $password, isSecure: true, tag: 2)
                                .frame(height: 40, alignment: .center)
                                .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                                .frame(maxWidth: maxWidth)
                                .padding([.top, .bottom], 4)
                                .padding([.leading, .trailing], horizontalPadding)
                                .onChange(of: password) { newValue in
                                    validatePw()
                                }
                        } else {
                            passwordView("New Password", textfield: $password, isSecure: false, tag: 2)
                                .frame(height: 40, alignment: .center)
                                .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                                .frame(maxWidth: maxWidth)
                                .padding([.top, .bottom], 4)
                                .padding([.leading, .trailing], horizontalPadding)
                                .onChange(of: password) { newValue in
                                    validatePw()
                                }
                        }
                        HStack(spacing: 0) {
                            Spacer()
                            
                            Button(action: {
                                print("Toggling hide password flag")
                                self.hidePassword.toggle()
                            }) {
                                Image(systemName: hidePassword ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(Color.black.opacity(0.7))
                            }
                            .frame(maxWidth: 40, maxHeight: 40, alignment: .center)
                            .mask(RoundedRectangle(cornerRadius: 90))
                            .background(Color.themeAccent.opacity(0.01))
                            
                        }
                        .padding([.leading, .trailing],horizontalPadding)
                    }
                    .padding(0)
                    
                    Text($passwordMsg.wrappedValue)
                        .frame(maxWidth: maxWidth, alignment: .center)
                        .padding(.bottom, 4)
                        .foregroundColor(passwordIsValid ? Color.themeValid : Color.themeError)
                    
                    ZStack {
                        if hidePassword2 {
                            passwordView("Confirm New Password", textfield: $password2, isSecure: true, tag: 3)
                                .frame(height: 40, alignment: .center)
                                .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                                .frame(maxWidth: maxWidth)
                                .padding([.top, .bottom], 4)
                                .padding([.leading, .trailing], horizontalPadding)
                                .onChange(of: password2) { newValue in
                                    validatePw2()
                                }
                        } else {
                            passwordView("Confirm New Password", textfield: $password2, isSecure: false, tag: 3)
                                .frame(height: 40, alignment: .center)
                                .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                                .frame(maxWidth: maxWidth)
                                .padding([.top, .bottom], 4)
                                .padding([.leading, .trailing], horizontalPadding)
                                .onChange(of: password2) { newValue in
                                    validatePw2()
                                }
                        }
                        
                        HStack(spacing: 0) {
                            Spacer()
                            
                            Button(action: {
                                print("Toggling hide password2 flag")
                                self.hidePassword2.toggle()
                            }) {
                                Image(systemName: hidePassword2 ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(Color.black.opacity(0.7))
                            }
                            .frame(maxWidth: 40, maxHeight: 40, alignment: .center)
                            .mask(RoundedRectangle(cornerRadius: 90))
                            .background(Color.themeAccent.opacity(0.01))
                            
                        }
                        .padding([.leading, .trailing],horizontalPadding)
                    }
                    .padding(0)
                    
                
                Text($password2Msg.wrappedValue)
                    .frame(maxWidth: maxWidth, alignment: .center)
                    .padding(.bottom, 4)
                    .foregroundColor(password2IsValid ? Color.themeValid : Color.themeError)
                
                
                HStack (spacing: 20) {
                    Button(action: {
                        print("Updating")
                        if allFieldsValidated {
                            self.isUpdating = true
                            Api().changePassword(oldPassword: oldPassword, newPassword: password) { response in
                                print("Password Changed")
                                self.showAlert.toggle()
                            }

                        }
                    }) {
                        Text(isUpdating ? "Updating" : "Update")
                            .frame(minWidth: 100)
                            .padding()
                            .foregroundColor(Color.themeBackground)
                            .background(Capsule().fill(Color.themeAccent.opacity(disableUpdateButton || isUpdating ? 0.2 : 1.0)))
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
            validateOldPw()
        }
    }
    
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
