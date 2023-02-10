//
//  SettingsView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/24/22.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var profileData: ProfileData
    @ObservedObject var sessionAuth: SessionAuth
    @State private var showActionSheet = false
    @State private var isShowPhotoLibrary = false
    @State private var isShowCamera = false
    @State private var showSignIn = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Profile")
                    .bold()
                Spacer()
                Button {self.presentationMode.wrappedValue.dismiss()} label: {
                    Image("CloseIcon")
                        .foregroundColor(Color("Text"))
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
            .padding(.bottom, 10)
            
            VStack {
                if sessionAuth.isUserLoggedIn() {
                    Button(action: {isShowPhotoLibrary.toggle()}) {
                        ZStack {
                            ProfileView(profile: $profileData.profile, size: 100)
                                .overlay(alignment: .bottomTrailing) {
                                    Image("EditIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color.black)
                                        .frame(width: 10, height: 10)
                                        .padding(10)
                                        .background(Color("BrandLightGreen"))
                                        .cornerRadius(50)
                                }
                        }
                    }
                    .padding(.bottom)
                    Text(profileData.profile.username)
                        .foregroundColor(Color.black)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    Text(profileData.profile.email)
                        .foregroundColor(Color.black)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                }
            }
            
            Spacer()
            
            if (sessionAuth.isUserLoggedIn()) {
                Button(action: {
                    profileData.signOut()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Sign Out")
                        .bold()
                        .frame(width: 360, height: 50)
                        .background(.thinMaterial)
                        .foregroundColor(Color.red)
                        .cornerRadius(10)
                }
            } else {
                Button(action: {showSignIn.toggle()}) {
                    Text("Sign In")
                        .bold()
                        .frame(width: 360, height: 50)
                        .background(.thinMaterial)
                        .foregroundColor(Color.green)
                        .cornerRadius(10)
                }
            }
        }
        .navigationTitle("Profile")
        .padding()
        .sheet(isPresented: $showSignIn) {
            UserAuthView(viewRouter: ViewRouter(), profileData: profileData)
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ProfilePicker(profileData: self.profileData)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}

// from https://github.com/appcoda/ImagePickerSwiftUI
struct ProfilePicker: UIViewControllerRepresentable {
 
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
 
    @ObservedObject var profileData: ProfileData
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ProfilePicker>) -> UIImagePickerController {
 
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
 
        return imagePicker
    }
 
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ProfilePicker>) {
 
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ProfilePicker
        
        init(_ parent: ProfilePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.profileData.profile.imageData = image.jpegData(compressionQuality: 0.1)
                parent.profileData.updateProfileImage(imageData: parent.profileData.profile.imageData!) { err in
                    if err == nil {
                        print("Error updating user")
                    }
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(profileData: ProfileData(), sessionAuth: SessionAuth())
    }
}
