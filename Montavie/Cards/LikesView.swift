//
//  AllLikesView.swift
//  Montavie
//
//  Created by Oliver Lance on 2/17/23.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

// all comments in one place for main poster
struct LikesView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var likeData: LikeData
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack {
                Text("Likes")
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
                ForEach(likeData.likes.sorted(by: >), id: \.key) { key, value in
                    HStack {
                        Text(value)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                        Spacer()
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
        .padding(.bottom, 50)
        .padding()
    }
}

struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
        LikesView(likeData: LikeData())
    }
}
