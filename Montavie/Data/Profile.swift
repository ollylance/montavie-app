//
//  Profile.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 12/20/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Shimmer
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct Profile: Identifiable, Equatable, Hashable, Codable {
    var id: UUID = UUID()
    var username: String = ""
    var imageURL: URL? = nil
    var imageData: Data? = nil
    var email: String = ""
}

class ProfileData: ObservableObject {
    @Published var profile = Profile()
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.profile = Profile()
        } catch {
            print("Error signing out.")
        }
    }
    
    func fetchProfile() {
        if (Auth.auth().currentUser?.uid != nil) {
            self.profile = Profile(username: Auth.auth().currentUser!.displayName ?? "", imageURL: Auth.auth().currentUser!.photoURL, email: Auth.auth().currentUser!.email ?? "")
        } else {
            self.profile = Profile()
        }
    }
    
//    combine these three functions with proper guard stuff
    func updateUsername(username: String, completion: @escaping((String?) -> ())) {
        if (Auth.auth().currentUser != nil) {
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    completion(nil)
                    return
                } else {
                    self.profile.username = username
                    completion("Username Updated")
                }
            }
        }
    }
    
    func updateProfileImage(imageData: Data, completion: @escaping((String?) -> ())) {
        if (Auth.auth().currentUser?.uid != nil) {
            self.uploadProfile(image: imageData) { (url) in
                if url != nil {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.photoURL = URL(string: url!)
                    changeRequest?.commitChanges { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                            completion(nil)
                            return
                        } else {
                            self.profile.imageURL = URL(string: url!)
                            self.profile.imageData = nil
                            completion("Profile Image Updated")
                        }
                    }
                }
            }
        }
    }
    
    func updateProfile(username: String, imageData: Data, completion: @escaping((String?) -> ())) {
        if (Auth.auth().currentUser?.uid != nil) {
            self.uploadProfile(image: imageData) { (url) in
                if url != nil {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.photoURL = URL(string: url!)
                    changeRequest?.displayName = username
                    changeRequest?.commitChanges { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                            completion(nil)
                            return
                        }
                        self.profile.imageURL = URL(string: url!)
                        self.profile.username = username
                        self.profile.imageData = nil
                        completion("Profile Updated")
                        return
                    }
                } else {
                    completion(nil)
                    return
                }
            }
        } else {
            completion(nil)
        }
    }
    
    private func uploadProfile(image: Data?, completion: @escaping((String?) -> ())) {
        if (Auth.auth().currentUser?.uid != nil) {
            let storageRef = self.storage.reference()
            
            // Create a reference to the file you want to upload
            let profileRef = storageRef.child("profiles/\(Auth.auth().currentUser!.uid).jpg")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            profileRef.putData(image!, metadata: metadata) { metadata, error in
                guard error == nil else {
                    // Uh-oh, an error occurred!
                    print("Error adding image: \(error!)")
                    completion(nil)
                    return
                }
                
                profileRef.downloadURL { (url, error) in
                    guard url != nil else {
                        print("Error: no download url.")
                        completion(nil)
                        return
                    }
                    completion(url?.absoluteString)
                }
            }
        }
    }
}

struct ProfileView: View {
    @Binding var profile: Profile
    var size: CGFloat
    
    var body: some View {
        ZStack {
            if (profile.imageData != nil) {
                ImageHelper().getSafeImage(data: profile.imageData)
                    .resizable()
            } else {
                WebImage(url: profile.imageURL)
                    .resizable()
                    .placeholder {
                        Image("SettingsIcon")
                            .frame(width: size, height: size)
                            .foregroundColor(Color.black)
                    }
            }
        }
        .scaledToFill()
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
