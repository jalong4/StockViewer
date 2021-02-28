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
        self.emailIsValid = email.isValidEmail()
        self.passwordIsValid = password.isValidPassword()
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
    
    
    var body: some View {
        ZStack {
            Color.themeBackground
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack(spacing: 4,  content: {
                
                if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                    // ~Equivalent to iPhone portrait
                    profileImageIconView
                        .padding(.top, 80)
                        .padding(.bottom, 14)
                        .font(.system(size: 100, weight: .thin))
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 10)
                }
                
                Text($msg.wrappedValue)
                    .frame(maxWidth: maxWidth, alignment: .center)
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
                    SettingsManager.sharedInstance.profileImageUrl = profileImageUrl
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
                        self.appState.isLoggedIn = true
                        self.appState.needsRefreshData = true
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
