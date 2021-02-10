//
//  LoginView.swift
//  StockViewer
//
//  Created by Jim Long on 2/8/21.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @State var creatingAccount = SettingsManager.sharedInstance.creatingAccount ?? false
    @State private var email: String = SettingsManager.sharedInstance.email ?? ""
    @State private var password: String = SettingsManager.sharedInstance.password ?? ""
    @State private var loggingIn: Bool = false
    @State private var showPassword: Bool = false
    
    var body: some View {
        if !self.creatingAccount {
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
                        AuthUtils().handleLogin(email: email, password: password)
                    }) {
                        Text(self.loggingIn ? "Logging in..." : "Login")
                            .frame(width: 90)
                            .padding()
                            .foregroundColor(.white)
                            .background(
                                Capsule()
                                    .fill(Color.themeAccent).opacity(loggingIn ? 0.6 : 1.0))
                        
                        
                    }
                    .disabled(email.isEmpty || password.isEmpty || self.loggingIn)
                    .padding([.top], 20)
                    
                    Button(action: {
                        self.creatingAccount = true
                        SettingsManager.sharedInstance.creatingAccount = true;
                        NotificationCenter.default.post(name: NSNotification.Name("RegisterEvent"), object: nil)
                    }, label: {
                        Text("Create a new account")
                            .padding([.leading, .trailing], 40)
                            .padding([.top], 20)
                        
                    })
                    Spacer()
                    
                })
            }
            .navigationTitle("Login")
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("LoginEvent"), object: nil, queue: .main) { (_) in
                    self.creatingAccount = SettingsManager.sharedInstance.creatingAccount ?? false
                }
            }
            .onDisappear() {
                NotificationCenter.default.removeObserver("LoginEvent")
            }
        } else {
            RegisterView()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
