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
import MapKit

struct PostView: View {
    @ObservedObject var sessionAuth: SessionAuth
    @ObservedObject var profileData: ProfileData
    @ObservedObject var likeData: LikeData
    @ObservedObject var commentData: CommentData
    @Binding var post: Post
    @Binding var show: Bool
    @State var showLocation = false
    @State var showComments = false
    @State var showBanner: Bool = false
    @State var showLikes: Bool = false
    var namespace: Namespace.ID
    
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
                    .matchedGeometryEffect(id: post.id.uuidString + "image", in: namespace)
                    .frame(minWidth: 200, maxWidth: .infinity)
                    .mask(RoundedRectangle(cornerRadius: 20).matchedGeometryEffect(id: post.id.uuidString + "clipmask", in: namespace))
                    
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
                        Spacer()
                        if ((post.location) != nil) {
                            Button(action: {showLocation.toggle()}) {
                                Image("LocationIcon")
                                    .blending(color: Color("LightText"))
                                    .frame(width: 35, height: 35)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Text(getFormattedDate(format: "MM/dd/yyyy", date: post.date))
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(Color("LightText"))
                        .matchedGeometryEffect(id: post.id.uuidString + "date", in: namespace)
                        .padding(.horizontal)
                    Text(getFormattedDate(format: "h:mm a", date: post.date))
                        .font(.system(size: 25, weight: .light, design: .rounded))
                        .foregroundColor(Color("LightText"))
                        .matchedGeometryEffect(id: post.id.uuidString + "time", in: namespace)
                        .padding(.horizontal)
                    Text(post.text)
                        .font(.system(size: 25, weight: .medium, design: .rounded))
                        .foregroundColor(Color("LightText"))
                        .padding()
                    Spacer()
                }
            }
            .background(Color(post.color).matchedGeometryEffect(id: post.id.uuidString + "background", in: namespace))
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous).matchedGeometryEffect(id: post.id.uuidString + "mask", in: namespace))
            .ignoresSafeArea()
            
            Button {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                    show = false
                }
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
        .fullScreenCover(isPresented: $showLocation) {
            LocationView(post: $post)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        PostView(sessionAuth: SessionAuth(), profileData: ProfileData(), likeData: LikeData(), commentData: CommentData(), post: .constant(Post(text: "hello")), show: .constant(true), namespace: namespace)
    }
}

struct HeartView {
    @ObservedObject var likeData: LikeData
    @Binding var post: Post
    @Binding var showLikes: Bool
    @Binding var showBanner: Bool
    
    var HeartButtonView: some View {
        HStack {
            ZStack {
                Image("HeartIcon")
                Image("HeartIconFilled")
                    .opacity(isLiked() ? 1 : 0)
                    .scaleEffect(isLiked() ? 1.0 : 0.1)
            }
            .blending(color: isLiked() ? .red : Color("LightText"))
            .frame(width: 35, height: 35)
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    let impactMed = UIImpactFeedbackGenerator(style: .light)
                    impactMed.impactOccurred()
                    likeData.likePost(post: post)
                }
            }
            
            Text(likeData.likeCount != 1 ? "**\(likeData.likeCount)** likes" : "**1** like")
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundColor(Color("LightText"))
                .padding(.leading, -5)
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        let impactMed = UIImpactFeedbackGenerator(style: .light)
                        impactMed.impactOccurred()
                        showLikes.toggle()
                    }
                }
        }
        .font(.system(size: 25))
        .foregroundColor(isLiked() ? .red : Color("LightText"))
    }
    
    var HeartButtonBlockedView: some View {
        HStack {
            Image("HeartBlockedIcon")
            .blending(color: isLiked() ? .red : Color("LightText"))
            .frame(width: 35, height: 35)
            .onTapGesture {
                let impactMed = UIImpactFeedbackGenerator(style: .light)
                impactMed.impactOccurred()
                showBanner = true
            }
            
            Text(likeData.likeCount != 1 ? "**\(likeData.likeCount)** likes" : "**1** like")
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundColor(Color("LightText"))
                .padding(.leading, -5)
                .onTapGesture {
                    let impactMed = UIImpactFeedbackGenerator(style: .light)
                    impactMed.impactOccurred()
                    showLikes.toggle()
                }
        }
        .font(.system(size: 25))
        .foregroundColor(isLiked() ? .red : Color("LightText"))
    }
    
    var BlockedNotification: some View {
        ZStack {
            if showBanner {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("To like a post, please sign in!")
                                .font(Font.system(size: 15, weight: .light, design: .rounded))
                        }
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .padding(12)
                    .background(Color("BrandLightGreen"))
                    .cornerRadius(20)
                    Spacer()
                }
                .padding()
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.showBanner = false
                    }
                }.onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            self.showBanner = false
                        }
                    }
                })
            }
        }
    }
    
    func isLiked() -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else {
            return false
        }
        return likeData.likes[uid] != nil
    }
}

// from https://trailingclosure.com/notification-banner-using-swiftui/


struct ImageHelper {
    func getSafeImage(data: Data?) -> Image {
        let uiImage: UIImage
        if (data != nil && UIImage(data: data!) != nil) {
            uiImage = UIImage(data: data!)!
        } else {
            uiImage = UIImage(named: "AppIcon")!
        }
        return Image(uiImage: uiImage)
    }
}

