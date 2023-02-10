//
//  ColorSelectionView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/21/22.
//

import SwiftUI

struct ColorSelectionView: View {
    @Binding var color: String
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
    ]
    
    var colors : [String] = ["BrandCoral", "BrandFlame", "BrandMoss", "BrandLightGreen", "BrandDarkGreen", "BrandMyrtleGreen", "BrandMunsell", "BrandBlue", "BrandLightGrey", "BrandDarkGrey"]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(colors, id: \.self) { colorName in
                    Button(action: {color = colorName}) {
                        if colorName == color {
                            Circle()
                                .strokeBorder(Color("BrandDarkGrey"), lineWidth: 2)
                                .background(Circle().foregroundColor(Color(colorName)))
                                .shadow(radius: 10)
                        } else {
                            Circle()
                                .foregroundColor(Color(colorName))
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct ColorSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSelectionView(color: .constant("BrandCoral"))
    }
}
