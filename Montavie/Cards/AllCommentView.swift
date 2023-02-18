//
//  AllCommentView.swift
//  Montavie
//
//  Created by Oliver Lance on 2/10/23.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

// all comments in one place for main poster
struct AllCommentView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var sessionAuth: SessionAuth
    @ObservedObject var commentData: CommentData
    @ObservedObject var likeData: LikeData
    @State var selectedPost: Post = Post()
    @State var showPost = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack {
                Text("All Comments")
                    .padding()
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                Spacer()
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("CloseIcon")
                        .foregroundColor(Color("Text"))
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .padding(.trailing)
            }
            
            LazyVStack(spacing: 0.5) {
                ForEach($commentData.comments) { $comment in
                    Button(action: {
                        commentData.getPost(id: comment.postID) { post in
                            selectedPost = post
                            if selectedPost.key != "" {
                                showPost.toggle()
                            }
                        }
                    }) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 10) {
                                Text(comment.username)
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(getFormattedDate(format: "MM/dd/yyyy", date: comment.datePosted))
                                        .font(.system(size: 10, weight: .light, design: .rounded))
                                    Text(getFormattedDate(format: "h:mm a", date: comment.datePosted))
                                        .font(.system(size: 10, weight: .light, design: .rounded))
                                    
                                }.padding(.trailing)
                            }
                            Text(comment.comment)
                                .font(.system(size: 15, weight: .light, design: .rounded))
                        }
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .padding(.bottom, 50)
        .padding()
        .task {
            commentData.fetchAllComments()
        }
        .onChange(of: showPost) { new in
            if new == true {
                likeData.getLikes(post: selectedPost)
                commentData.fetchComments(postID: selectedPost.key)
            } else {
                commentData.fetchAllComments()
            }
        }
        .fullScreenCover(isPresented: $showPost) {
            PostViewSimple(post: $selectedPost, sessionAuth: sessionAuth, profileData: ProfileData(), likeData: likeData, commentData: commentData)
        }
    }
}

struct AllCommentView_Previews: PreviewProvider {
    static var previews: some View {
        AllCommentView(sessionAuth: SessionAuth(), commentData: CommentData(), likeData: LikeData())
    }
}
