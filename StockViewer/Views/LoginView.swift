//
//  LoginView.swift
//  StockViewer
//
//  Created by Jim Long on 2/8/21.
//

import SwiftUI

struct LoginView: View {
    @Binding var createAccount: Bool

    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @EnvironmentObject var appData: AppData
    
    @State private var email: String = SettingsManager.sharedInstance.email ?? ""
    @State private var password: String = SettingsManager.sharedInstance.password ?? ""
    
    @State private var emailIsValid = false
    @State private var passwordIsValid = false
    
    @State private var loggingIn: Bool = false
    @State private var hidePassword = true
    @State private var disableButton: Bool = false
    
    @State private var showDefaultProfileImage = false
    @State var profileImageModel: UrlImageModel?
    
    @State private var loginError: Bool = false
    @State private var msg = "Please Login"
    @State private var emailMsg = ""
    @State private var passwordMsg = ""

    
    
    var allFieldsValidated: Bool {
        self.emailIsValid = email.isValidEmail()
        self.passwordIsValid = password.isValidPassword()
        let result = emailIsValid && passwordIsValid
        if result {
            msg = "Please Login"
        }
        return result
    }
    
    
    var body: some View {
        ZStack {
            Color.themeBackground
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack(spacing: 0,  content: {
                
                if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                    // ~Equivalent to iPhone portrait
                    SvProfileIconView(profileImageUrl: .constant(SettingsManager.sharedInstance.profileImageUrl), sfSymbolName: "person.circle", viewOnly: true)
                }
                
                Text($msg.wrappedValue)
                    .frame(maxWidth: Constants.textFieldMaxWidth, alignment: .center)
                    .padding(.bottom, 14)
                    .foregroundColor(msg == "Please Login" ? Color.themeForeground : Color.themeError)
                
                SvTextField(placeholder: "email", text: $email, isValid: $emailIsValid, textMsg: $emailMsg,
                            validationCallback: {
                                return ValidationResult(isValid: email.isValidEmail(),
                                                        errorMessage: email.inValidEmailMessage())
                            },
                            onChangeHandler: {
                                self.disableButton = !allFieldsValidated
                            }
                )
                
                
                SvSecureTextField(placeholder: "password", text: $password, isValid: $passwordIsValid,
                                  tag: 2,
                                  validationCallback: {
                                    return ValidationResult(
                                        isValid: password.isValidPassword(),
                                        errorMessage: password.invalidPasswordMessage()
                                  )},
                                  onChangeHandler: {
                                    self.disableButton = !allFieldsValidated
                                  }
                )
                
                Button(action: {
                    self.loggingIn = true
                    SettingsManager.sharedInstance.email = email
                    SettingsManager.sharedInstance.password = password
                    AuthUtils().logOut()
                    self.loginError = false
                    
                    Api().login(email: email, password: password, completion: { loginResponse in
                        guard
                            let auth = loginResponse.response.auth,
                            let accessTokenProperties = try? JSONEncoder().encode(auth.accessTokenProperties)
                        else {
                            self.loggingIn = false
                            self.loginError = true
                            msg = "Invalid email or password"
                            return
                        }
                        
                        SettingsManager.sharedInstance.accessToken = auth.accessToken
                        SettingsManager.sharedInstance.refreshToken = auth.refreshToken
                        SettingsManager.sharedInstance.profileImageUrl = loginResponse.response.user?.profileImageUrl
                        SettingsManager.sharedInstance.accessTokenProperties = String(data: accessTokenProperties, encoding: .utf8)
                        SettingsManager.sharedInstance.isLoggedIn = true;
                        if !self.appData.isLoggedIn {
                            self.appData.isLoggedIn.toggle()
                        }
                        self.appData.needsRefreshData = true
                    })
                }) {
                    Text(self.loggingIn ? "Logging in..." : "Login")
                        .frame(width: 90)
                        .padding()
                        .foregroundColor(Color.themeBackground)
                        .background(Capsule().fill(disableButton || loggingIn ? Color.themeAccentFaded : Color.themeAccent))
                    
                    
                }
                .disabled(disableButton || loggingIn)
                .padding([.top], 20)
                
                Button(action: {
                    self.createAccount.toggle()
                }, label: {
                    Text("Create a new account")
                        .padding([.leading, .trailing], 40)
                        .padding([.top], 20)
                    
                })
                Spacer()
                
            })
        }
        .dismissKeyboardOnTap()
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            self.disableButton = !allFieldsValidated
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(createAccount: .constant(false))
    }
}
