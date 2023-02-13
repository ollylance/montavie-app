//
//  SignUpView.swift
//  Montavie
//
//  Created by Oliver Lance on 2/5/23.
//

import SwiftUI
import FirebaseAuth

// UI View modified from https://github.com/BLCKBIRDS/Authentication-with-SwiftUI-and-Firebase
struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var profileData: ProfileData
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    
    @State var signUpProcessing = false
    @State var signUpErrorMessage = ""
    
    var body: some View {
        VStack(spacing: 15) {
            LogoView()
                .padding(.bottom)
            Text("montavie")
                .padding(.bottom, 50)
                .font(.system(size: 45, weight: .light, design: .rounded))
            SignUpCredentialFields(username: $username, email: $email, password: $password)
            Button(action: {
                signUpUser(userEmail: email, userPassword: password)
            }) {
                Text("Log In")
                    .bold()
                    .frame(width: 360, height: 50)
                    .background(.thinMaterial)
                    .cornerRadius(20)
            }
            .disabled(!signUpProcessing && !email.isEmpty && !password.isEmpty ? false : true)
            Group {
                if signUpProcessing {
                    ProgressView()
                }
                if !signUpErrorMessage.isEmpty {
                    Text("Failed creating an account.")
                        .foregroundColor(.red)
                }
            }
            Spacer()
            HStack {
                Text("Have an account?")
                Button(action: {
                    viewRouter.currentPage = .signInPage
                }) {
                    Text("Sign In")
                }
            }
                .opacity(0.9)
        }
        .padding()
    }
    
    func signUpUser(userEmail: String, userPassword: String) {
        signUpProcessing = true
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            guard error == nil else {
                signUpProcessing = false
                signUpErrorMessage = error!.localizedDescription
                return
            }
            switch authResult {
            case .none:
                signUpProcessing = false
                signUpErrorMessage = "Could not create account."
            case .some(_):
                let imageData = UIImage(named: "ProfileTemp")!.jpegData(compressionQuality: 1.0)
                profileData.updateProfile(username: username, imageData: imageData!) { success in
                    guard success != nil else {
                        print("Error uploading information.")
                        signUpProcessing = false
                        signUpErrorMessage = "Could not create account."
                        return
                    }
                    profileData.fetchProfile()
                    self.presentationMode.wrappedValue.dismiss()
                    signUpProcessing = false
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewRouter: ViewRouter(), profileData: ProfileData())
    }
}

struct SignUpCredentialFields: View {
    @Binding var username: String
    @Binding var email: String
    @Binding var password: String

    var body: some View {
        TextField("Display Name", text: $username)
            .padding()
            .background(Color("LightText"))
            .cornerRadius(20)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
        
        TextField("Email", text: $email)
            .padding()
            .background(Color("LightText"))
            .cornerRadius(20)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)

        SecureField("Password", text: $password)
            .padding()
            .background(Color("LightText"))
            .cornerRadius(20)
            .padding(.bottom, 30)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
    }
}
