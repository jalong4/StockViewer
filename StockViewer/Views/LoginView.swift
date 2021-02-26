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
    @EnvironmentObject var appState: AppState
    

    @State private var profileImage: UIImage?
    @State private var profileImageUrl: String?
    
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
    
    let horizontalPadding: CGFloat = 40
    let maxWidth: CGFloat = .infinity
    
    
    var allFieldsValidated: Bool {
        let result = emailIsValid && passwordIsValid
        if result {
            msg = "Please Login"
        }
        return result
    }
    
    var profileImageIconView: AnyView {
        
        if let profileImage = profileImage {
            return AnyView(Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 10, x: 0, y: 5))
        } else {
            return AnyView(UrlImageView(urlImageModel: $profileImageModel, showDefault: $showDefaultProfileImage, defaultImageSystemName: "person.circle"))
        }
        
    }
    
    private func passwordView(_ label: String, textfield: Binding<String>, isSecure: Bool, tag: Int) -> CustomTextField {
        return CustomTextField(label, text: textfield, isSecure: isSecure, textAlignment: .left, tag: tag, onCommit: nil)
    }
    
    private func validatePw() {
        self.passwordMsg = ""
        if (password.isEmpty || password.count < 6) {
            self.passwordMsg = password.isEmpty ? "Enter a password" : "Password must be at least 6 characters"
            self.passwordIsValid = false
            self.disableButton = !allFieldsValidated
            return
        }
        self.passwordIsValid = true
        self.disableButton = !allFieldsValidated
    }
    
    var body: some View {
        ZStack {
            Color.themeBackground
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack(spacing: 10,  content: {
                
                if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                    // ~Equivalent to iPhone portrait
                    profileImageIconView
                        .padding(.top, 100)
                        .padding(.bottom, 10)
                        .font(.system(size: 100, weight: .thin))
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 10)
                }
                
                Text($msg.wrappedValue)
                    .frame(maxWidth: maxWidth, alignment: .center)
                    .padding(.bottom, 4)
                    .foregroundColor(msg == "Please Login" ? Color.themeForeground : Color.themeError)
                
                
                
                VStack{

                    CustomTextField("email", text: $email, textAlignment:  .left, tag: 1, onCommit: nil)
                        .frame(height: 40, alignment: .center)
                        .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                        .frame(maxWidth: maxWidth)
                        .padding([.top, .bottom], 2)
                        .padding([.leading, .trailing], horizontalPadding)
                        .onChange(of: email) { newValue in
                            if (email.isEmpty || !email.isValidEmail()) {
                                self.emailMsg = email.isEmpty ? "Enter an email address" : "Invalid email address"
                                self.emailIsValid = false
                                self.disableButton = !allFieldsValidated
                                return
                            }
                            self.emailIsValid = true
                            self.emailMsg = ""
                            self.disableButton = !allFieldsValidated
                        }
                    
                    Text($emailMsg.wrappedValue)
                        .frame(maxWidth: maxWidth, alignment: .center)
                        .padding(.bottom, 4)
                        .foregroundColor(emailIsValid ? Color.themeValid : Color.themeError)
                    
                    ZStack {
                        
                        if hidePassword {
                            passwordView("password", textfield: $password, isSecure: true, tag: 4)
                                .frame(height: 40, alignment: .center)
                                .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                                .frame(maxWidth: maxWidth)
                                .padding([.top, .bottom], 2)
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
                }
                
                
                Button(action: {
                    self.loggingIn = true
                    SettingsManager.sharedInstance.email = email
                    SettingsManager.sharedInstance.password = password
                    SettingsManager.sharedInstance.profileImageUrl = profileImageUrl
                    AuthUtils().logOut()
                    self.loginError = false
                    
                    Api().login(email: email, password: password, completion: { loginResponse in
                        guard
                            let accessToken = loginResponse.response.auth?.accessToken,
                            let refreshToken = loginResponse.response.auth?.refreshToken,
                            let accessTokenPropertiesData = try? JSONEncoder().encode(loginResponse.response.auth?.accessTokenProperties),
                            let accessTokenPropertiesString = String(data: accessTokenPropertiesData, encoding: .utf8)
                        else {
                            self.loggingIn = false
                            self.loginError = true
                            msg = "Invalid email or password"
                            return
                        }
                        
                        SettingsManager.sharedInstance.accessToken = accessToken
                        SettingsManager.sharedInstance.refreshToken = refreshToken
                        SettingsManager.sharedInstance.profileImageUrl = loginResponse.response.user?.profileImageUrl
                        SettingsManager.sharedInstance.accessTokenProperties = accessTokenPropertiesString
                        SettingsManager.sharedInstance.isLoggedIn = true;
                        self.appState.isLoggedIn = true
                        self.appState.needsRefreshData = true
                    })
                }) {
                    Text(self.loggingIn ? "Logging in..." : "Login")
                        .frame(width: 90)
                        .padding()
                        .foregroundColor(Color.themeBackground)
                        .background(Capsule().fill(Color.themeAccent.opacity(email.isEmpty || password.isEmpty || self.loggingIn ? 0.2 : 1.0)))
                    
                    
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
            self.emailIsValid = !email.isEmpty && email.isValidEmail()
            validatePw()
            self.disableButton = !allFieldsValidated
            if let url = SettingsManager.sharedInstance.profileImageUrl {
                profileImageUrl = url
                profileImageModel = UrlImageModel(urlString: $profileImageUrl)
                profileImageModel?.loadImage()
            } else {
                    showDefaultProfileImage = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(createAccount: .constant(false))
    }
}
