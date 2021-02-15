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
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.themeBackground
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack(spacing: 10,  content: {
                    
                    Image(systemName: "person.crop.circle.badge.plus")
                        .padding()
                        .font(.system(size: 100, weight: .thin))
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 10)
                    Text("Account Profile")
                        .padding()
                    TextField("First Name", text: $firstName)
                        .textFieldModifier()
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                    TextField("Last Name", text: $lastName)
                        .textFieldModifier()
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                    TextField("email", text: $email)
                        .textFieldModifier()
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                    SecureField("password", text: $password)
                        .textFieldModifier()
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                    SecureField("Re-enter password", text: $password2)
                        .textFieldModifier()
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                    HStack (spacing: 20) {
                        Button(action: {
                            print("Updating profile")
                            // Todo - call service to update profile
                            self.appState.navigateToProfile.toggle()
                        }) {
                            Text("Update")
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                                .primaryButtonTextModifier()
                        }
                        Button(action: {
                            print("Canceling")
                            self.appState.navigateToProfile.toggle()
                        }) {
                            Text("Cancel")
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                                .cancelButtonTextModifier()
                        }
                    }
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                    Spacer()
                    
                })
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
