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

struct PostView: View {
    @ObservedObject var sessionAuth: SessionAuth
    @Binding var post: Post
    @Binding var show: Bool
    @State var showLocation = false
    @State var showComments = false
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
                    
                    HStack {
                        Text(getFormattedDate(format: "MM/dd/yyyy", date: post.date))
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(Color("LightText"))
                            .matchedGeometryEffect(id: post.id.uuidString + "date", in: namespace)
                            .padding(.horizontal)
                        Spacer()
                        Button(action: {showComments.toggle()}) {
                            Image("CommentIcon")
                                .blending(color: Color("LightText"))
                                .frame(width: 35, height: 35)
                        }
                        .padding(.trailing)
                        if ((post.location) != nil) {
                            Button(action: {showLocation.toggle()}) {
                                Image("LocationIcon")
                                    .blending(color: Color("LightText"))
                                    .frame(width: 35, height: 35)
                            }
                            .padding(.trailing)
                        }
                    }
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
        }
        .fullScreenCover(isPresented: $showComments) {
            CommentView(post: $post, sessionAuth: sessionAuth)
        }
        .fullScreenCover(isPresented: $showLocation) {
            LocationView(post: $post)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        PostView(sessionAuth: SessionAuth(), post: .constant(Post(text: "hello")), show: .constant(true), namespace: namespace)
    }
}

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

