//
//  ProfileView.swift
//  StockViewer
//
//  Created by Jim Long on 2/8/21.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var password2 = ""
    
    @State private var hidePassword = true
    @State private var hidePassword2 = true
    
    let horizontalPadding: CGFloat = 40
    let maxWidth: CGFloat = .infinity
    
    @State private var isUpdating: Bool = false
    @State private var disableUpdateButton: Bool = true
    
    @State private var firstNameMsg = ""
    @State private var lastNameMsg = ""
    @State private var emailMsg = ""
    @State private var passwordMsg = ""
    @State private var password2Msg = ""
    
    @State private var showAlert = false
    @State private var firstNameIsValid = false
    @State private var lastNameIsValid = false
    @State private var emailIsValid = false
    @State private var passwordIsValid = false
    @State private var password2IsValid = false
    
    
    var allFieldsValidated: Bool {
        return firstNameIsValid && lastNameIsValid && passwordIsValid && password2IsValid
    }
    
    private func passwordView(_ label: String, textfield: Binding<String>, isSecure: Bool, tag: Int) -> CustomTextField {
        return CustomTextField(label, text: textfield, isSecure: isSecure, textAlignment: .left, tag: tag, onCommit: nil)
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
                
                Image(systemName: "person.crop.circle.badge.plus")
                    .padding(.top, 100)
                    .padding(.bottom, 10)
                    .font(.system(size: 100, weight: .thin))
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 10)
                
                Group {
                    
                    CustomTextField("First Name", text: $firstName, autocapitalization: .words, textAlignment:  .left, tag: 1, onCommit: nil)
                        .frame(height: 40, alignment: .center)
                        .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                        .frame(maxWidth: maxWidth)
                        .padding([.top, .bottom], 4)
                        .padding([.leading, .trailing], horizontalPadding)
                        .onChange(of: firstName) { newValue in
                            self.firstNameMsg = ""
                            if (firstName.isEmpty) {
                                self.firstNameMsg = "Enter a first name"
                                self.firstNameIsValid = false
                                self.disableUpdateButton = !allFieldsValidated
                                return
                            }
                            self.firstNameIsValid = true
                            self.disableUpdateButton = !allFieldsValidated
                        }
                    
                    
                    Text($firstNameMsg.wrappedValue)
                        .frame(maxWidth: maxWidth, alignment: .center)
                        .padding(.bottom, 4)
                        .foregroundColor(firstNameIsValid ? Color.themeValid : Color.themeError)
                    
                    CustomTextField("Last Name", text: $lastName, autocapitalization: .words, textAlignment:  .left, tag: 2, onCommit: nil)
                        .frame(height: 40, alignment: .center)
                        .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                        .frame(maxWidth: maxWidth)
                        .padding([.top, .bottom], 4)
                        .padding([.leading, .trailing], horizontalPadding)
                        .onChange(of: lastName) { newValue in
                            self.lastNameMsg = ""
                            if (lastName.isEmpty) {
                                self.lastNameMsg = "Enter a last name"
                                self.lastNameIsValid = false
                                self.disableUpdateButton = !allFieldsValidated
                                return
                            }
                            self.lastNameIsValid = true
                            self.disableUpdateButton = !allFieldsValidated
                        }
                    
                    Text($lastNameMsg.wrappedValue)
                        .frame(maxWidth: maxWidth, alignment: .center)
                        .padding(.bottom, 4)
                        .foregroundColor(lastNameIsValid ? Color.themeValid : Color.themeError)
                }
                
                CustomTextField("email", text: $email, textAlignment:  .left, tag: 3, onCommit: nil)
                    .frame(height: 40, alignment: .center)
                    .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                    .frame(maxWidth: maxWidth)
                    .padding([.top, .bottom], 4)
                    .padding([.leading, .trailing], horizontalPadding)
                    .onChange(of: email) { newValue in
                        self.emailMsg = ""
                        if (email.isEmpty || !email.isValidEmail()) {
                            self.emailMsg = email.isEmpty ? "Enter an email address" : "Invalid email address"
                            self.emailIsValid = false
                            self.disableUpdateButton = !allFieldsValidated
                            return
                        }
                        self.emailIsValid = true
                        self.disableUpdateButton = !allFieldsValidated
                    }
                
                Text($emailMsg.wrappedValue)
                    .frame(maxWidth: maxWidth, alignment: .center)
                    .padding(.bottom, 4)
                    .foregroundColor(emailIsValid ? Color.themeValid : Color.themeError)
                
                
                Group {
                    
                    ZStack {
                        
                        if hidePassword {
                            passwordView("password", textfield: $password, isSecure: true, tag: 4)
                                .frame(height: 40, alignment: .center)
                                .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                                .frame(maxWidth: maxWidth)
                                .padding([.top, .bottom], 4)
                                .padding([.leading, .trailing], horizontalPadding)
                                .onChange(of: password) { newValue in
                                    validatePw()
                                }
                        } else {
                            passwordView("password", textfield: $password, isSecure: false, tag: 4)
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
                            passwordView("password2", textfield: $password2, isSecure: true, tag: 5)
                                .frame(height: 40, alignment: .center)
                                .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                                .frame(maxWidth: maxWidth)
                                .padding([.top, .bottom], 4)
                                .padding([.leading, .trailing], horizontalPadding)
                                .onChange(of: password2) { newValue in
                                    validatePw2()
                                }
                        } else {
                            passwordView("password2", textfield: $password2, isSecure: false, tag: 5)
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
                    
                }
                
                Text($password2Msg.wrappedValue)
                    .frame(maxWidth: maxWidth, alignment: .center)
                    .padding(.bottom, 4)
                    .foregroundColor(password2IsValid ? Color.themeValid : Color.themeError)
                
                
                HStack (spacing: 20) {
                    Button(action: {
                        print("Updating")
                        if allFieldsValidated {
                            self.isUpdating = true
                            // ToDo call service to update profile
                            self.showAlert.toggle()
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
                        return Alert(title: Text("Profile Updated"),
                                     message: nil,
                                     dismissButton: .default(Text("Ok"), action: {
                                        appState.showingProfile = false
                                        appState.showingStockTable = true
                                     }))
                    })
                    
                    Button(action: {
                        print("Canceling")
                        appState.showingProfile = false
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
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
