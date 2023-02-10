//
//  CommentView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 2/5/23.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct CommentView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var post: Post
    @ObservedObject var sessionAuth: SessionAuth
    @ObservedObject var commentData = CommentData()
    @StateObject private var keyboard = KeyboardResponder()
    @State var comment: String = ""
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Text("Comments")
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
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 10) {
                                ZStack {
                                    WebImage(url: URL(string: comment.userProfileURL))
                                        .resizable()
                                        .placeholder {
                                            Circle().foregroundColor(Color("BrandLightGrey"))
                                                .shimmering()
                                        }
                                        .scaledToFill()
                                }
                                .foregroundColor(Color.white)
                                .frame(width: 30, height: 30)
                                .mask(Circle())
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
                        .frame(maxWidth: .infinity)
                        .padding()
                        .modifier(ContextModifier(commentData: commentData, comment: comment))
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .padding(.bottom, 50)
            .padding()
            
            KeyboardInput
        }
        .task {
            commentData.fetchComments(postID: post.key)
        }
    }
}

extension CommentView {
    var KeyboardInput: some View {
        VStack {
            Spacer()
            HStack {
                TextField(sessionAuth.isUserLoggedIn() ? "Comment" : "Please log in to comment.", text: $comment)
                    .padding()
                    .background(Color("LightText"))
                    .cornerRadius(20)
                    .textInputAutocapitalization(.sentences)
                    .disabled(!sessionAuth.isUserLoggedIn())
                Button(action: {
                    if comment != "" {
                        commentData.addComment(post: post, comment: comment, user: Auth.auth().currentUser) { success in
                            guard success else {
                                return
                            }
                            comment = ""
                        }
                    }
                }) {
                    if (sessionAuth.isUserLoggedIn()) {
                        Image("SendIcon")
                            .foregroundColor(Color.black)
                            .frame(width: 30, height: 30)
                            .padding(5)
                            .background(Color("BrandLightGreen"))
                            .cornerRadius(20)
                    } else {
                        Image("LockIcon")
                            .foregroundColor(Color.black)
                            .frame(width: 30, height: 30)
                            .padding(5)
                            .background(Color("BrandLightGrey"))
                            .cornerRadius(20)
                    }
                }
                .disabled(!sessionAuth.isUserLoggedIn())
            }
                .padding()
                .background(Color.white)
        }
    }
}

extension CommentView {
    struct ContextModifier: ViewModifier {
        // ContextMenu Modifier
        @ObservedObject var commentData: CommentData
        var comment: Comment
        
        func body(content: Content) -> some View {
            content
                .contextMenu(menuItems: {
                    if (comment.uid == Auth.auth().currentUser?.uid) {
                        Button(action: {
                            commentData.deleteComment(key: comment.key)
                        }) {
                            Text("Delete")
                                .bold()
                                .foregroundColor(Color.red)
                        }
                    }
                })
                .contentShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(post: .constant(Post()), sessionAuth: SessionAuth(), commentData: CommentData())
    }
}
