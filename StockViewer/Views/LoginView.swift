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
    
    @State private var email: String = SettingsManager.sharedInstance.email ?? ""
    @State private var password: String = SettingsManager.sharedInstance.password ?? ""
    @State private var loggingIn: Bool = false
    @State private var showPassword: Bool = false
    
    var body: some View {
        ZStack {
            Color.themeBackground
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack(spacing: 10,  content: {
                
                if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                    // ~Equivalent to iPhone portrait
                    Image(systemName: "person.circle")
                        .padding()
                        .font(.system(size: 100, weight: .thin))
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 10)
                }
                
                Text("Please Login")
                    .padding()
                
                
                
                VStack{
                    TextField("email", text: $email)
                        .textFieldModifier()
                        .autocapitalization(.none)
                        .frame(maxWidth: .infinity)
                        .padding([.leading], 40)
                        .padding([.trailing], 40)
                    ZStack {
                        if showPassword {
                            TextField("password", text: $password)
                                .textFieldModifier()
                                .frame(maxWidth: .infinity)
                                .padding([.leading], 40)
                                .padding([.trailing], 40)
                        } else{
                            SecureField("password", text: $password)
                                .textFieldModifier()
                                .frame(maxWidth: .infinity)
                                .padding([.leading], 40)
                                .padding([.trailing], 40)
                        }
                        Button(action: {
                            self.showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(Color.black.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding([.trailing], 50)
                        
                    }
                }
                
                
                Button(action: {
                    self.loggingIn = true
                    SettingsManager.sharedInstance.email = email
                    SettingsManager.sharedInstance.password = password
                    AuthUtils().logOut()
                    
                    Api().login(email: email, password: password, completion: { loginResponse in
                        SettingsManager.sharedInstance.accessToken = loginResponse.response.auth.accessToken
                        SettingsManager.sharedInstance.refreshToken = loginResponse.response.auth.refreshToken
                        
                        guard
                            let accessTokenPropertiesData = try? JSONEncoder().encode(loginResponse.response.auth.accessTokenProperties),
                            let accessTokenPropertiesString = String(data: accessTokenPropertiesData, encoding: .utf8)
                        else { return }
                        
                        SettingsManager.sharedInstance.accessTokenProperties = accessTokenPropertiesString
                        SettingsManager.sharedInstance.isLoggedIn = true;
                        self.appState.isLoggedIn = true
                    })
                }) {
                    Text(self.loggingIn ? "Logging in..." : "Login")
                        .frame(width: 90)
                        .padding()
                        .foregroundColor(Color.themeBackground)
                        .background(Capsule().fill(Color.themeAccent.opacity(email.isEmpty || password.isEmpty || self.loggingIn ? 0.3 : 1.0)))
                    
                    
                }
                .disabled(email.isEmpty || password.isEmpty || self.loggingIn)
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
        .navigationTitle("Login")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(createAccount: .constant(false))
    }
}
