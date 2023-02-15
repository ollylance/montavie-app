//
//  CommentData.swift
//  Montavie
//
//  Created by Oliver Lance on 2/6/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import PhotosUI

struct Comment: Identifiable, Equatable, Hashable, Codable {
    var id: UUID = UUID()
    var comment: String = ""
    var postID: String = ""
    var uid: String = ""
    var username: String = ""
    var userProfileURL: String = ""
    var datePosted: Date = Date()
    var key: String = ""
}

class CommentData: ObservableObject {
    @Published var comments = [Comment]()
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    
    func fetchComments(postID: String) {
        db.collection("comments").order(by: "datePosted", descending: true).whereField("postID", isEqualTo: postID).addSnapshotListener { (snap, err) in
            guard let documents = snap?.documents else {
                return
            }
            self.comments = documents.map { (queryDocumentSnapshot) -> Comment in
                let data = queryDocumentSnapshot.data()
                let key = queryDocumentSnapshot.documentID
                let timestamp = data["datePosted"] as? Timestamp
                let comment = data["comment"] as? String
                let postID = data["postID"] as? String
                let username = data["username"] as? String
                let uid = data["uid"] as? String
                
                return Comment(comment: comment ?? "", postID: postID ?? "", uid: uid ?? "", username: username ?? "", datePosted: timestamp!.dateValue(), key: key)
            }
            
            if self.comments.count != 0 {
                for index in 0..<self.comments.count {
                    self.getProfileImageURL(uid: self.comments[index].uid) { url in
                        self.comments[index].userProfileURL = url
                    }
                }
            }
        }
    }
    
    func fetchAllComments() {
        db.collection("comments").order(by: "datePosted", descending: true).addSnapshotListener { (snap, err) in
            guard let documents = snap?.documents else {
                return
            }
            
            self.comments = documents.map { (queryDocumentSnapshot) -> Comment in
                let data = queryDocumentSnapshot.data()
                let key = queryDocumentSnapshot.documentID
                let timestamp = data["datePosted"] as? Timestamp
                let comment = data["comment"] as? String
                let postID = data["postID"] as? String
                let username = data["username"] as? String
                let uid = data["uid"] as? String
                
                return Comment(comment: comment ?? "", postID: postID ?? "", uid: uid ?? "", username: username ?? "", datePosted: timestamp!.dateValue(), key: key)
            }
        }
    }
    
    private func getProfileImageURL(uid: String, completion: @escaping((String) -> ())) {
        let storageRef = self.storage.reference()
        
        let profileRef = storageRef.child("profiles/\(uid).jpg")
        profileRef.downloadURL { (url, error) in
            guard url != nil else {
                print("Error: no download url.")
                completion("")
                return
            }
            completion(url?.absoluteString ?? "")
        }
    }
    
    func addComment(post: Post, comment: String, user: User?, completion: @escaping((Bool) -> ())) {
        guard user != nil else {
            print("User not signed in.")
            completion(false)
            return
        }
        self.db.collection("comments").addDocument(data: [
            "datePosted": Timestamp(date: Date()),
            "comment": comment,
            "postID": post.key,
            "username": user?.displayName ?? "",
            "uid": user?.uid ?? ""
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
                completion(false)
            } else {
                print("Comment successfully written")
                completion(true)
            }
        }
    }
    
    func deleteComment(key: String) {
        self.db.collection("comments").document(key).delete() { err in
            if let err = err {
                print("Error deleting document: \(err)")
            }
        }
    }
    
    func reportComment(comment: Comment) {
        self.db.collection("reports").addDocument(data: [
            "uid": comment.uid,
            "commentID": comment.key,
            "comment": comment.comment,
            "username": comment.username,
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
        }
    }
    
    func getPost(id: String, completion: @escaping((Post) -> ())) {
        self.db.collection("posts").document(id).getDocument { (snap, err) in
            guard snap?.exists != nil && snap!.exists else {
                completion(Post())
                return
            }
            let data = snap!.data()!
            let key = snap!.documentID
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
            completion(Post(date: timestamp!.dateValue(),
                                   color: color!,
                                   text: text!,
                                   size: size ?? "landscape",
                                   imageURL: imageURL!,
                                   uid: uid ?? "",
                                   key: key,
                                   location: location))
            
        }
    }
}
