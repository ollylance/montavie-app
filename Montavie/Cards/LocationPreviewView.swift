//
//  LocationPreviewView.swift
//  Montavie
//
//  Created by Oliver Lance on 2/4/23.
//

import SwiftUI
import SDWebImageSwiftUI

// some UI references received from https://www.youtube.com/watch?v=Ca0SisRHYuY&list=PLwvDm4Vfkdpha5eVTjLM0eRlJ7-yDDwBk&index=7
struct LocationPreviewView: View {
    @State var post: Post
    @ObservedObject var sessionAuth: SessionAuth
    @ObservedObject var profileData: ProfileData
    @ObservedObject var mapData: MapData
    @State var isOpenPost = false
    
    var body: some View {
        HStack (alignment: .bottom) {
            VStack(alignment: .leading) {
                imageSection
                dateSection
            }
            
            VStack(spacing: 8) {
                Button {
                    isOpenPost.toggle()
                } label: {
                    Text("More")
                        .font(.headline)
                        .frame(width: 150, height: 35)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(post.color))
                
                HStack {
                    Button {
                        mapData.prevLocation()
                    } label: {
                        ZStack {
                            Image("NextLeftIcon")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(post.color))
                                .frame(width: 18, height: 18)
                        }
                        .frame(width: 60, height: 35)
                    }
                    .buttonStyle(.bordered)
                    .tint(Color(post.color))
                    
                    Button {
                        mapData.nextLocation()
                    } label: {
                        ZStack {
                            Image("NextRightIcon")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(post.color))
                                .frame(width: 18, height: 18)
                        }
                        .frame(width: 60, height: 35)
                    }
                    .buttonStyle(.bordered)
                    .tint(Color(post.color))
                }
                
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 20)
            .fill(.ultraThinMaterial)
            .offset(y: 65))
        .cornerRadius(20)
        .fullScreenCover(isPresented: $isOpenPost) {
            PostViewSimple(post: $post, sessionAuth: sessionAuth, profileData: profileData)
        }
    }
}

struct LocationPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        LocationPreviewView(post: Post(), sessionAuth: SessionAuth(), profileData: ProfileData(), mapData: MapData())
            .padding()
    }
}

extension LocationPreviewView {
    private var imageSection: some View {
        ZStack {
            ZStack {
                if (post.imageData != nil) {
                    ImageHelper().getSafeImage(data: post.imageData)
                        .resizable()
                        .scaledToFill()
                } else {
                    WebImage(url: URL(string: post.imageURL))
                        .onSuccess { image, data, cacheType in
                            post.imageData = image.jpegData(compressionQuality: 1.0)
                        }
                        .resizable()
                        .placeholder {
                            Rectangle().foregroundColor(Color("LightText"))
                                .shimmering()
                        }
                        .scaledToFill()
                }
            }
            .foregroundColor(Color.white)
            .frame(width: 100, height: 100)
            .mask(RoundedRectangle(cornerRadius: 20))
        }
        .padding(10)
        .background(Color(post.color))
        .cornerRadius(20)
    }
    
    private var dateSection: some View {
        VStack(alignment: .leading) {
            Text(getFormattedDate(format: "MM/dd/yyyy", date: post.date))
                .font(.system(size: 18, weight: .bold, design: .rounded))
            Text(getFormattedDate(format: "h:mm a", date: post.date))
                .font(.system(size: 15, weight: .light, design: .rounded))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
