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
//
//    @State private var showDefaultProfileImage = false
//    @State var profileImageModel: UrlImageModel?
  
    @State private var profileImageUrl: String?
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""

    
    @State private var isUpdating: Bool = false
    @State private var disableUpdateButton: Bool = false
    

    @State private var firstNameMsg = ""
    @State private var lastNameMsg = ""
    @State private var emailMsg = ""
    
    @State private var showAlert = false
    @State private var firstNameIsValid = false
    @State private var lastNameIsValid = false
    @State private var emailIsValid = false
//
//    @State private var isShowPhotoLibrary = false
//    @State private var profileImage: UIImage?

    
    @State private var user: User?
    
    
    var allFieldsValidated: Bool {
        return firstNameIsValid && lastNameIsValid && emailIsValid
    }
    
    func updateUser() {
        guard var user = user else { return }
        
        user.profileImageUrl = profileImageUrl
        user.firstName = self.firstName
        user.lastName = self.lastName
        user.email = self.email
        Api().updateUser(user: user) { user in
            print("User Updated")
            print(user)
        }
    }
    
    var body: some View {
        
        ZStack {
            Color.themeBackground
            
            VStack(alignment: .center, spacing: 0,  content: {
                
                SvProfileIconView(profileImageUrl: $profileImageUrl, sfSymbolName: "person.crop.circle.badge.plus")
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                
                SvTextField(placeholder: "First Name", text: $firstName, isValid: $firstNameIsValid, autocapitalization: .words, textMsg: $firstNameMsg,
                            validationCallback: {
                                return ValidationResult(isValid: !firstName.isEmpty,
                                                        errorMessage: "Enter a First Name")
                            },
                            onChangeHandler: {
                                self.disableUpdateButton = !allFieldsValidated
                            }
                )
                
                SvTextField(placeholder: "Last Name", text: $lastName, isValid: $lastNameIsValid, autocapitalization: .words, tag: 2, textMsg: $lastNameMsg,
                            validationCallback: {
                                return ValidationResult(isValid: !lastName.isEmpty,
                                                        errorMessage: "Enter a Last Name")
                            },
                            onChangeHandler: {
                                self.disableUpdateButton = !allFieldsValidated
                            }
                )
                
                SvTextField(placeholder: "email", text: $email, isValid: $emailIsValid, tag: 3, textMsg: $emailMsg,
                            validationCallback: {
                                return ValidationResult(isValid: email.isValidEmail(),
                                                        errorMessage: email.inValidEmailMessage())
                            },
                            onChangeHandler: {
                                self.disableUpdateButton = !allFieldsValidated
                            }
                )
                
                
                HStack (spacing: 20) {
                    Button(action: {
                        print("Updating")
                        if allFieldsValidated {
                            self.isUpdating = true
                            
                            if let _ = user {
                                updateUser()
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
                .frame(maxWidth: Constants.textFieldMaxWidth)
                .padding([.leading, .trailing], Constants.horizontalPadding)
                
                Spacer()
                
            })
        }
        .dismissKeyboardOnTap()
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            self.profileImageUrl = SettingsManager.sharedInstance.profileImageUrl
            Api().getUser { user in
                if let user = user {
                    print(user)
                    self.firstName = user.firstName
                    self.lastName = user.lastName
                    self.email = user.email
                    self.user = user
                    self.profileImageUrl = user.profileImageUrl
                    print("profileImageUrl is " + (self.profileImageUrl ?? "nil"))
                    SettingsManager.sharedInstance.profileImageUrl = user.profileImageUrl
                    self.disableUpdateButton = !allFieldsValidated
                }
            }
        }
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
