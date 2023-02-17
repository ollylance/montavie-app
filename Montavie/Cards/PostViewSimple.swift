//
//  PostView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/12/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Shimmer
import FirebaseAuth

// PostViewSimple is the regular PostView without the MatchedGeometryEffects and location
struct PostViewSimple: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var post: Post
    @ObservedObject var sessionAuth: SessionAuth
    @ObservedObject var profileData: ProfileData
    @ObservedObject var likeData: LikeData
    @ObservedObject var commentData: CommentData
    @State var showComments = false
    @State var showBanner: Bool = false
    @State var showLikes: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ZStack {
                        if (post.imageData != nil) {
                            ImageHelper().getSafeImage(data: post.imageData)
                                .resizable()
                                .scaledToFill()
                        } else {
                            WebImage(url: URL(string: post.imageURL))
                                .resizable()
                                .placeholder {
                                    Rectangle().foregroundColor(Color("LightText"))
                                        .shimmering()
                                }
                                .scaledToFill()
                        }
                    }
                    .foregroundColor(Color.white)
                    .frame(minWidth: 200, maxWidth: .infinity)
                    .mask(RoundedRectangle(cornerRadius: 20))
                    
                    HStack (spacing: 10) {
                        Button(action: {showComments.toggle()}) {
                            Image("CommentIcon")
                                .blending(color: Color("LightText"))
                                .frame(width: 35, height: 35)
                            Text(commentData.comments.count != 1 ? "**\(commentData.comments.count)** comments" : "**1** comment")
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .foregroundColor(Color("LightText"))
                                .padding(.leading, -5)
                        }
                        ZStack {
                            if sessionAuth.isUserLoggedIn() {
                                HeartView(likeData: likeData, post: $post, showLikes: $showLikes, showBanner: $showBanner).HeartButtonView
                            } else {
                                HeartView(likeData: likeData, post: $post, showLikes: $showLikes, showBanner: $showBanner).HeartButtonBlockedView
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Text(getFormattedDate(format: "MM/dd/yyyy", date: post.date))
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(Color("LightText"))
                        .padding(.horizontal)
                    Text(getFormattedDate(format: "h:mm a", date: post.date))
                        .font(.system(size: 25, weight: .light, design: .rounded))
                        .foregroundColor(Color("LightText"))
                        .padding(.horizontal)
                    Text(post.text)
                        .font(.system(size: 25, weight: .medium, design: .rounded))
                        .foregroundColor(Color("LightText"))
                        .padding()
                    Spacer()
                }
            }
            .background(Color(post.color))
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .ignoresSafeArea()
            
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image("CloseIcon")
                    .foregroundColor(Color("Text"))
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.trailing, 40)
            
            HeartView(likeData: likeData, post: $post, showLikes: $showLikes, showBanner: $showBanner).BlockedNotification
        }
        .sheet(isPresented: $showLikes) {
            LikesView(likeData: likeData)
        }
        .fullScreenCover(isPresented: $showComments) {
            CommentView(post: $post, profileData: profileData, sessionAuth: sessionAuth, commentData: commentData)
        }
    }
}

struct PostViewSimple_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        PostViewSimple(post: .constant(Post(text: "hello")), sessionAuth: SessionAuth(), profileData: ProfileData(), likeData: LikeData(), commentData: CommentData())
    }
}

