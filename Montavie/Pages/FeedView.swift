//
//  FeedView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/12/22.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct FeedView: View {
    @ObservedObject var feedData: FeedData
    @ObservedObject var profileData: ProfileData
    @ObservedObject var sessionAuth: SessionAuth
    @State var firstAppear = true
    @State var showProfile = false
    @Namespace var namespace
    @State var show: Bool = false
    @State var selected: Post = Post()
    @State var isNewPostPresenting = false
    @State var isAllCommentsPresenting = false
    var currUID = Auth.auth().currentUser?.uid
    var footstepSize = 50
    let footstepSpacing: CGFloat = 20
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    HStack {
                        Text("Posts")
                            .padding()
                            .font(.system(size: 45, weight: .bold, design: .rounded))
                        Spacer()
                        
                        if Auth.auth().currentUser?.email == "olly.lance15@gmail.com" {
                            Button(action: {isNewPostPresenting.toggle()}) {
                                Image("PlusIcon")
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(Color.black)
                            }
                            .padding([.vertical, .leading])
                            .padding(.trailing, 5)
                            
                            Button(action: {isAllCommentsPresenting.toggle()}) {
                                Image("CommentIcon")
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(Color.black)
                            }
                            .padding([.vertical, .leading])
                            .padding(.trailing, 5)
                        }
                        
                        Button(action: {showProfile.toggle()}) {
                            ProfileView(profile: $profileData.profile, size: 45)
                        }
                        .padding()
                    }
                    VStack {
                        ForEachWithIndex(data: $feedData.posts) { index, $post in
                            HStack {
                                if (index % 2 == 0) {
                                    Footsteps(footstepSize: footstepSize, footstepSpacing: footstepSpacing, startLeft: true, currentLast: post == feedData.posts.last, post: $post, feedData: feedData)
                                    Spacer()
                                }
                                ZStack {
                                    if !(selected.id == post.id && show) {
                                        PostCardView(post: $post, show: $show, namespace: namespace)
                                            .modifier(ContextModifier(feedData: feedData, post: post))
                                            .shadow(color: Color(post.color), radius: 20, x: 0, y: 15)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                    }
                                    else {
                                        PostCardGhostView(post: $post)
                                            .modifier(ContextModifier(feedData: feedData, post: post))
                                            .shadow(color: Color(post.color), radius: 20, x: 0, y: 15)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                if (index % 2 == 1) {
                                    Spacer()
                                    Footsteps(footstepSize: footstepSize, footstepSpacing: footstepSpacing, startLeft: false, currentLast: post == feedData.posts.last, post: $post, feedData: feedData)
                                }
                            }
                            .onTapGesture {
                                selected = post
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                                    show = true
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
                .sheet(isPresented: $showProfile) {
                    SettingsView(profileData: profileData, sessionAuth: sessionAuth)
                        .presentationDetents([.height(sessionAuth.isUserLoggedIn() ? 350 : 180)])
                }
                .fullScreenCover(isPresented: $isNewPostPresenting) {
                    NewPostView()
                }
                .fullScreenCover(isPresented: $isAllCommentsPresenting) {
                    AllCommentView(sessionAuth: sessionAuth, commentData: CommentData())
                }
            }
            if show {
                PostView(sessionAuth: sessionAuth, post: $selected, show: $show, namespace: namespace)
            }
        }
    }
}

struct Footsteps: View {
    @State var footstepSize: Int
    @State var footstepSpacing: CGFloat
    @State var startLeft: Bool
    @State var currentLast: Bool
    @State var fetched = false
    @Binding var post: Post
    @ObservedObject var feedData: FeedData
    
    var body: some View {
        ZStack {
            LazyVStack {
                ForEach(0..<(Int(getCardType(card: post.size).height)+60) / footstepSize, id: \.self) { i in
                    ZStack {
                        if (startLeft && i % 2 == 0 || !startLeft && i % 2 == 1) {
                            Footstep(footstepSize: footstepSize, foot: "LeftFootstep", post: post)
                                .padding(.trailing, footstepSpacing)
                        } else {
                            Footstep(footstepSize: footstepSize, foot: "RightFootstep", post: post)
                                .padding(.leading, footstepSpacing)
                        }
                    }
                    .onAppear {
                        if (currentLast && !fetched) {
                            fetched = true
                            feedData.getNextPosts()
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct Footstep: View {
    @State var footstepSize: Int
    @State var foot: String
    @State private var opacity = false
    @State var post: Post
    
    var body: some View {
        ZStack {
            Image(foot)
                .resizable()
                .scaledToFit()
                .padding(0)
                .foregroundColor(Color(post.color))
        }
        .opacity(opacity ? 0.3 : 0.0)
        .frame(height: CGFloat(footstepSize))
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5)) {
                opacity = true
            }
        }
    }
}
                                
struct ForEachWithIndex<
    Data: RandomAccessCollection,
    Content: View
>: View where Data.Element: Identifiable {
    let data: Data
    @ViewBuilder let content: (Data.Index, Data.Element) -> Content

    var body: some View {
        ForEach(Array(zip(data.indices, data)), id: \.1.id) { index, element in
            content(index, element)
        }
    }
}

struct ContextModifier: ViewModifier {
    // ContextMenu Modifier
    @ObservedObject var feedData: FeedData
    var post: Post

    func body(content: Content) -> some View {
        content
            .contextMenu(menuItems: {
                if (post.uid == Auth.auth().currentUser?.uid) {
                    Button(action: {
                        feedData.deletePost(post: post)
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

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(feedData: FeedData(), profileData: ProfileData(), sessionAuth: SessionAuth())
    }
}
