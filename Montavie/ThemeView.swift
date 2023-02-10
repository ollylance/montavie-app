//
//  ThemeView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/12/22.
//

import SwiftUI

struct FontStyle: ViewModifier {
    var size: CGFloat
    var color: Color
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: .medium, design: .rounded))
            .foregroundColor(color)
    }
}

