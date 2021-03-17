//
//  RegisterView.swift
//  StockViewer
//
//  Created by Jim Long on 2/8/21.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var appData: AppData
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @Binding var createAccount: Bool
    
    @State private var profileImageUrl: String?
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var password2 = ""
    
    @State private var firstNameMsg = ""
    @State private var lastNameMsg = ""
    @State private var emailMsg = ""
    
    @State private var hidePassword = true
    @State private var hidePassword2 = true
    
    @State private var showAlert = false
    @State private var firstNameIsValid = false
    @State private var lastNameIsValid = false
    @State private var emailIsValid = false
    @State private var passwordIsValid = false
    @State private var password2IsValid = false
    
    
    @State private var loginError: Bool = false
    @State private var msg = "Please Register"
    
    
    @State private var isRegistering: Bool = false
    @State private var disableButton: Bool = false
    
    var allFieldsValidated: Bool {
        return firstNameIsValid && lastNameIsValid && emailIsValid
    }
    
    var body: some View {
        
        ZStack {
            Color.themeBackground
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack(spacing: 0,  content: {
                if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                    // ~Equivalent to iPhone portrait
                    SvProfileIconView(profileImageUrl: $profileImageUrl, sfSymbolName: "person.crop.circle.badge.plus")
                }
                
                Text($msg.wrappedValue)
                    .frame(maxWidth: Constants.textFieldMaxWidth, alignment: .center)
                    .padding(.bottom, 14)
                    .foregroundColor(msg == "Please Register" ? Color.themeForeground : Color.themeError)
                
                SvTextField(placeholder: "First Name", text: $firstName, isValid: $firstNameIsValid, autocapitalization: .words, textMsg: $firstNameMsg,
                            validationCallback: {
                                return ValidationResult(isValid: !firstName.isEmpty,
                                                        errorMessage: "Enter a First Name")
                            },
                            onChangeHandler: {
                                self.disableButton = !allFieldsValidated
                            }
                )
                
                SvTextField(placeholder: "Last Name", text: $lastName, isValid: $lastNameIsValid, autocapitalization: .words, tag: 2, textMsg: $lastNameMsg,
                            validationCallback: {
                                return ValidationResult(isValid: !lastName.isEmpty,
                                                        errorMessage: "Enter a Last Name")
                            },
                            onChangeHandler: {
                                self.disableButton = !allFieldsValidated
                            }
                )
                
                SvTextField(placeholder: "email", text: $email, isValid: $emailIsValid,
                            tag: 3, textMsg: $emailMsg,
                            validationCallback: {
                                return ValidationResult(isValid: email.isValidEmail(),
                                                        errorMessage: email.inValidEmailMessage())
                            },
                            onChangeHandler: {
                                self.disableButton = !allFieldsValidated
                            }
                )
                SvSecureTextField(placeholder: "New Password", text: $password, isValid: $passwordIsValid,
                                  tag: 4,
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
                                    self.disableButton = !allFieldsValidated
                                  }
                )
                
                SvSecureTextField(placeholder: "Confirm New Password", text: $password2, isValid: $password2IsValid,
                                  tag: 5,
                                  validationCallback: {
                                    return ValidationResult(
                                        isValid: password == password2,
                                        errorMessage: password2.isEmpty ? "Re-enter new password" : "Passwords don't match"
                                    )},
                                  onChangeHandler: {
                                    self.disableButton = !allFieldsValidated
                                  }
                )
                
                HStack (spacing: 20) {
                    Button(action: {
                        print("Registering")
                        if allFieldsValidated {
                            self.isRegistering = true
                            var user = [String: String]()
                            user["firstName"] = firstName
                            user["lastName"] = lastName
                            user["email"] = email
                            user["password"] = password
                            user["password2"] = password2
                            if let url = profileImageUrl {
                                user["profileImageUrl"] = url
                            }
                            
                            Api().registerUser(user: user) { response in
                                print("Registration Completed Successfully")
                                self.showAlert.toggle()
                                
                                guard
                                    let auth = response.response.auth,
                                    let user = response.response.user,
                                    let accessTokenProperties = try? JSONEncoder().encode(auth.accessTokenProperties)
                                else {
                                    self.isRegistering = false
                                    //                                    self.registrationError = true
                                    //                                    msg = response.error
                                    return
                                }
                                
                                SettingsManager.sharedInstance.email = user.email
                                SettingsManager.sharedInstance.password = self.password
                                SettingsManager.sharedInstance.accessToken = auth.accessToken
                                SettingsManager.sharedInstance.refreshToken = auth.refreshToken
                                SettingsManager.sharedInstance.profileImageUrl = response.response.user?.profileImageUrl
                                SettingsManager.sharedInstance.accessTokenProperties = String(data: accessTokenProperties, encoding: .utf8)
                                SettingsManager.sharedInstance.isLoggedIn = true;
                                if !self.appData.isLoggedIn {
                                    self.appData.isLoggedIn.toggle()
                                }
                                self.appData.needsRefreshData = true
                                self.createAccount.toggle()
                                
                                
                            }
                        }
                    }) {
                        Text(isRegistering ? "Registering" : "Register")
                            .frame(minWidth: 100)
                            .padding()
                            .foregroundColor(Color.themeBackground)
                            .background(Capsule().fill(disableButton || isRegistering ? Color.themeAccentFaded : Color.themeAccent))
                    }
                    .disabled(disableButton || isRegistering)
                    .alert(isPresented: $showAlert, content: {
                        return Alert(title: Text("Registration Completed Successfully"),
                                     message: nil,
                                     dismissButton: .default(Text("Ok"), action: {
                                        appData.showingProfile = false
                                        appData.showingStockTable = true
                                     }))
                    })
                }
                .frame(maxWidth: Constants.textFieldMaxWidth)
                .padding([.leading, .trailing], Constants.horizontalPadding)
                
                Button(action: {
                    self.createAccount.toggle()
                }) {
                    Text("Already have an account")
                        .padding([.leading, .trailing], Constants.horizontalPadding)
                }
                .padding(.top, 20)
                
                Spacer()
                
            })
        }
        .dismissKeyboardOnTap()
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            self.disableButton = !allFieldsValidated
        }

    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(createAccount: .constant(false))
    }
}
