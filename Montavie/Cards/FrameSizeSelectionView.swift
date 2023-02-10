//
//  FrameSizeSelectionView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/21/22.
//

import SwiftUI
import Shimmer

struct FrameSizeSelectionView: View {
    @Binding var size: String
    var sizes : [PostCardSelect] = [.landscape, .square, .tall]
    
    var body: some View {
        HStack {
            ForEach(sizes, id: \.self) { cardSelect in
                Button(action: {size = cardSelect.name}) {
                    VStack {
                        if size == cardSelect.name {
                            Rectangle()
                                .foregroundColor(Color.white)
                                .frame(width: 40, height: cardSelect.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding([.leading, .trailing, .top])
                                .padding(.bottom, 30)
                                .shimmering()
                        } else {
                            Rectangle()
                                .foregroundColor(Color.white)
                                .frame(width: 40, height: cardSelect.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding([.leading, .trailing, .top])
                                .padding(.bottom, 30)
                        }
                    }
                    .padding(-8)
                    .background(Color("BrandLightGrey"))
                    .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

enum PostCardSelect: Hashable {
    case landscape, square, tall
    
    var name: String {
        switch self {
        case .landscape: return "landscape"
        case .square: return "square"
        case .tall: return "tall"
        }
    }
    
    var height: CGFloat {
        switch self {
        case .landscape: return 30
        case .square: return 40
        case .tall: return 50
        }
    }
}

struct FrameSizeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        FrameSizeSelectionView(size: .constant("tall"))
    }
}
