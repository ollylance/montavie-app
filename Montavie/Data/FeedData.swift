//
//  FeedData.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/12/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import PhotosUI

class FeedData: ObservableObject {
    @Published var posts = [Post]()

    @State var isFetchInProgress = false
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    var lastDoc: QueryDocumentSnapshot? = nil
    var paginationNum = 8
    
    func fetchData() {
        db.collection("posts").order(by: "date", descending: true).limit(to: paginationNum).addSnapshotListener { (snap, err) in
            guard let documents = snap?.documents else {
                return
            }
            
            self.posts = documents.map { (queryDocumentSnapshot) -> Post in
                let data = queryDocumentSnapshot.data()
                let key = queryDocumentSnapshot.documentID
                let timestamp = data["date"] as? Timestamp
                let text = data["text"] as? String
                let color = data["color"] as? String
                let imageURL = data["imageURL"] as? String
                let size = data["size"] as? String
                let uid = data["uid"] as? String
                let lat = data["lat"] as? Double
                let lng = data["lng"] as? Double
                var location: CLLocationCoordinate2D? = nil
                if (lat != nil && lng != nil && lat != 0.0 && lng != 0.0) {
                    location = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
                }
                return Post(date: timestamp!.dateValue(),
                             color: color!,
                             text: text!,
                             size: size ?? "landscape",
                             imageURL: imageURL!,
                             uid: uid ?? "",
                             key: key,
                             location: location)
            }
            
            self.lastDoc = snap!.documents.last
        }
    }
    
    func getNextPosts() {
        if !isFetchInProgress {
            self.isFetchInProgress = true
            if (self.lastDoc == nil) {
                return
            }
            db.collection("posts").order(by: "date", descending: true).start(afterDocument: self.lastDoc!).limit(to: paginationNum).getDocuments { (snap, err) in
                guard let documents = snap?.documents else {
                    return
                }
                
                for data in documents {
                    let key = data.documentID
                    let timestamp = data["date"] as? Timestamp
                    let text = data["text"] as? String
                    let color = data["color"] as? String
                    let imageURL = data["imageURL"] as? String
                    let size = data["size"] as? String
                    let uid = data["uid"] as? String
                    let lat = data["lat"] as? Double
                    let lng = data["lng"] as? Double
                    var location: CLLocationCoordinate2D? = nil
                    if (lat != nil && lng != nil && lat != 0.0 && lng != 0.0) {
                        location = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
                    }
                    self.posts.append(Post(date: timestamp!.dateValue(),
                                           color: color!,
                                           text: text!,
                                           size: size ?? "landscape",
                                           imageURL: imageURL!,
                                           uid: uid ?? "",
                                           key: key,
                                           location: location))
                }
                
                self.lastDoc = documents.last
                self.isFetchInProgress = false
            }
        }
    }
    
    func addPost(post: Post) {
        uploadImage(image: post.imageData) { (url) in
            self.db.collection("posts").addDocument(data: [
                "date": Timestamp(date: post.date),
                "color": post.color,
                "text": post.text,
                "imageURL": url ?? "",
                "size": post.size,
                "uid": post.uid,
                "lat": post.location?.latitude ?? 0.0,
                "lng": post.location?.longitude ?? 0.0
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written")
                }
            }
        }
    }
    
    func deletePost(post: Post) {
        deleteImage(post: post) { _ in
            self.db.collection("posts").document(post.key).delete() { err in
                if let err = err {
                    print("Error deleting document: \(err)")
                }
            }
        }
    }
    
    private func deleteImage(post: Post, completion: @escaping((Bool) -> ())) {
        self.db.collection("posts").document(post.key).getDocument { (document, error) in
            if let document = document, document.exists {
                let imagePath = document.data()?["imageURL"] as! String
                let imageRef = self.storage.reference(forURL: imagePath)
                imageRef.delete { error in
                    if let error = error {
                        print("Error deleting image: \(error)")
                        completion(false)
                        return
                    }
                    completion(true)
                }
            } else {
                print("Document does not exist")
                completion(false)
                return
            }
        }
    }
    
    private func uploadImage(image: Data?, completion: @escaping((String?) -> ())) {
        let storageRef = self.storage.reference()
        
        // Create a reference to the file you want to upload
        let postRef = storageRef.child("images/\(UUID()).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        postRef.putData(image!, metadata: metadata) { metadata, error in
            guard error == nil else {
                print("Error adding image: \(error!)")
                return
            }
            
            postRef.downloadURL { (url, error) in
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
