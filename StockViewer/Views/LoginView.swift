//
//  LoginView.swift
//  StockViewer
//
//  Created by Jim Long on 2/8/21.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Color.themeBackground
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack(spacing: 10,  content: {
               
                Image(systemName: "person.circle")
                    .padding()
                    .font(.system(size: 100, weight: .thin))
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 10)
                Text("Please Login")
                    .padding()
                TextField("email", text: $email)
                    .textFieldModifier()
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                SecureField("password", text: $password)
                    .textFieldModifier()
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                Button(action: {}) {
                    Text("Login")
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                        .buttonTextModifier()
                }
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                Button(action: {}) {
                    Text("Create a new account")
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                }
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                Spacer()
            
            })
        }.navigationTitle("Login")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
