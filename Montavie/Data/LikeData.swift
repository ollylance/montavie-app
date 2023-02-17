//
//  LikeData.swift
//  Montavie
//
//  Created by Oliver Lance on 2/17/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth


class LikeData: ObservableObject {
    @Published var likeCount: Int = 0
    @Published var likes: [String : String] = [:]
    
    private var db = Firestore.firestore()
    
    func getLikes(post: Post) {
        db.collection("likes").document(post.key).addSnapshotListener { (snap, err) in
            guard let document = snap?.data() else {
                return
            }
            self.likeCount = document["likeCount"] as? Int ?? 0
            self.likes = document["likes"] as? [String : String] ?? [:]
        }
    }
    
    // will handle if user is liking or unliking post
    func likePost(post: Post) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let ref = self.db.collection("likes").document(post.key)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let doc: DocumentSnapshot
            do {
                try doc = transaction.getDocument(ref)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            guard var likeCount: Int = doc.data()?["likeCount"] as? Int, var likes: [String : String] = doc.data()?["likes"] as? [String : String] else {
                transaction.setData(["likeCount": 1, "likes": [currentUser.uid: currentUser.displayName]], forDocument: ref)
                return
            }
            
            if let _ = likes[currentUser.uid] {
                // Unlike the post and remove self from likes
                likeCount -= 1
                likes.removeValue(forKey: currentUser.uid)
            } else {
                // Star the post and add self to stars
                likeCount += 1
                likes[currentUser.uid] = currentUser.displayName
            }
            transaction.updateData(["likeCount": likeCount, "likes": likes], forDocument: ref)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            }
        }
    }
}
