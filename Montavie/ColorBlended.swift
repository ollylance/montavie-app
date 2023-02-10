//
//  ColorBlended.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/18/22.
//

import Foundation
import SwiftUI

public struct ColorBlended: ViewModifier {
  fileprivate var color: Color
  
  public func body(content: Content) -> some View {
    VStack {
      ZStack {
        content
        color.blendMode(.sourceAtop)
      }
      .drawingGroup(opaque: false)
    }
  }
}

extension View {
  public func blending(color: Color) -> some View {
    modifier(ColorBlended(color: color))
  }
}
