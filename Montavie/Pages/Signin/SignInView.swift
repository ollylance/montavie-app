//
//  SignInView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/24/22.
//

import SwiftUI
import FirebaseAuth

// UI View modified from https://github.com/BLCKBIRDS/Authentication-with-SwiftUI-and-Firebase
struct SignInView: View {
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var profileData: ProfileData
    @State var email = ""
    @State var password = ""
    
    @State var signInProcessing = false
    @State var signInErrorMessage = ""
    
    var body: some View {
        VStack(spacing: 15) {
            LogoView()
                .padding(.bottom)
            Text("montavie")
                .padding(.bottom, 50)
                .font(.system(size: 45, weight: .light, design: .rounded))
            SignInCredentialFields(email: $email, password: $password)
            Button(action: {
                signInUser(userEmail: email, userPassword: password)
            }) {
                Text("Log In")
                    .bold()
                    .frame(width: 360, height: 50)
                    .background(.thinMaterial)
                    .cornerRadius(20)
            }
            .disabled(!signInProcessing && !email.isEmpty && !password.isEmpty ? false : true)
            Group {
                if signInProcessing {
                    ProgressView()
                }
                if !signInErrorMessage.isEmpty {
                    Text("Failed signing in.")
                        .foregroundColor(.red)
                }
            }
            Spacer()
            HStack {
                Text("Don't have an account?")
                Button(action: {
                    viewRouter.currentPage = .signUpPage
                }) {
                    Text("Sign Up")
                }
            }
                .opacity(0.9)
        }
        .padding()
    }
    
    func signInUser(userEmail: String, userPassword: String) {
        signInProcessing = true
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                signInProcessing = false
                signInErrorMessage = error!.localizedDescription
                return
                
            }
            profileData.fetchProfile()
            signInProcessing = false
            viewRouter.currentPage = .close
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewRouter: ViewRouter(), profileData: ProfileData())
    }
}

struct SignInCredentialFields: View {
    
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
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

struct LogoView: View {
    var body: some View {
        Image("Logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 150)
            .padding(.top, 70)
    }
}
