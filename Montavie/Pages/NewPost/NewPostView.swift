//
//  NewPostView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/13/22.
//

import SwiftUI
import FirebaseAuth

struct NewPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var feedData = FeedData()
    @State var post: Post = Post(uid: Auth.auth().currentUser?.uid ?? "")
    @State var page = 0
    @State var pushPost: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                NewPostAddView(post: $post)
            }
            .ignoresSafeArea(.keyboard)
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .light)
                        impactMed.impactOccurred()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("CloseIcon")
                            .blending(color: Color("BrandDarkGrey"))
                            .frame(width: 25, height: 25)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .light)
                        impactMed.impactOccurred()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        NavigationLink(destination: NewPostSettingsView(post: $post, pushPost: $pushPost)) {
                            HStack {
                                Image("ArrowRight")
                                    .blending(color: Color("BrandDarkGrey"))
                                    .frame(width: 25, height: 25)
                            }
                        }
                        .onChange(of: pushPost) { newValue in
                            feedData.addPost(post: post)
                            post = Post(uid: Auth.auth().currentUser?.uid ?? "")
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView()
    }
}
