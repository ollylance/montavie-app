//
//  PostCardView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/15/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Shimmer

struct PostCardView: View {
    @Binding var post: Post
    @Binding var show: Bool
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
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
            .matchedGeometryEffect(id: post.id.uuidString + "image", in: namespace)
            .frame(width: getCardType(card: post.size).width, height: getCardType(card: post.size).height)
            .mask(RoundedRectangle(cornerRadius: 20).matchedGeometryEffect(id: post.id.uuidString + "clipmask", in: namespace))
            .padding([.leading, .trailing, .top])
            
            Text(getFormattedDate(format: "MM/dd/yyyy", date: post.date))
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(Color("LightText"))
                .matchedGeometryEffect(id: post.id.uuidString + "date", in: namespace)
            Text(getFormattedDate(format: "h:mm a", date: post.date))
                .font(.system(size: 25, weight: .light, design: .rounded))
                .foregroundColor(Color("LightText"))
                .matchedGeometryEffect(id: post.id.uuidString + "time", in: namespace)
                .padding(.bottom)
        }
        .background(Color(post.color).matchedGeometryEffect(id: post.id.uuidString + "background", in: namespace))
        .mask(RoundedRectangle(cornerRadius: 20, style: .continuous).matchedGeometryEffect(id: post.id.uuidString + "mask", in: namespace))
    }
}

struct PostCardGhostView: View {
    @Binding var post: Post
    var color = Color.clear
    var body: some View {
        VStack {
            Rectangle()
            .foregroundColor(color)
            .frame(width: getCardType(card: post.size).width, height: getCardType(card: post.size).height)
            .mask(RoundedRectangle(cornerRadius: 20))
            .padding([.leading, .trailing, .top])
            
            Text("01/11/2001")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text("11:12 PM")
                .font(.system(size: 25, weight: .light, design: .rounded))
                .foregroundColor(color)
                .padding(.bottom)
        }
        .background(color)
        .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

func getCardType(card: String) -> PostCard {
    if (card == "tall") {
        return .tall
    } else if (card == "square") {
        return .square
    } else {
        return .landscape
    }
}

struct PostCardView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        VStack {
            PostCardView(post: .constant(Post()), show: .constant(true), namespace: namespace)
            PostCardGhostView(post: .constant(Post()))
        }
    }
}

enum PostCard: Hashable {
    case landscape, square, tall
    
    var width: CGFloat {
        switch self {
        case .landscape: return 190
        case .square: return 190
        case .tall: return 190
        }
    }
    
    var height: CGFloat {
        switch self {
        case .landscape: return 140
        case .square: return 190
        case .tall: return 240
        }
    }
}

