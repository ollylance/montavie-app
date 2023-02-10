//
//  NewPostSettingsView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/20/22.
//

import SwiftUI

struct NewPostSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var post: Post
    @Binding var pushPost: Bool
    @Namespace var namespace
    @State var show: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack {
                        PostCardView(post: $post, show: $show, namespace: namespace)
                            .padding(.bottom)
                            .shadow(color: Color(post.color), radius: 20, x: 0, y: 20)
                        ColorSelectionView(color: $post.color)
                            .padding()
                        FrameSizeSelectionView(size: $post.size)
                        Spacer()
                    }
                    .frame(
                      minWidth: 0,
                      maxWidth: .infinity,
                      minHeight: 0,
                      maxHeight: .infinity
                    )
                }
                Button(action: {
                    pushPost = true
                }) {
                    HStack {
                        Text("done")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(Color("BrandDarkGrey"))
//                        Image("Check")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .foregroundColor(Color.black)
                    .background(Color("BrandLightGreen"))
                    .cornerRadius(20)
                    .shadow(color: Color("BrandLightGreen"), radius: 5, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 20)
            }
            .ignoresSafeArea(.keyboard)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                let impactMed = UIImpactFeedbackGenerator(style: .light)
                impactMed.impactOccurred()
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("ArrowLeft")
                    .blending(color: Color("BrandDarkGrey"))
                    .frame(width: 25, height: 25)
            }
        )
    }
}

struct NewPostSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostSettingsView(post: .constant(Post()), pushPost: .constant(false))
    }
}
