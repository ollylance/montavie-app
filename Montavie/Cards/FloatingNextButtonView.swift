//
//  FloatingNextButtonView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/19/22.
//

import SwiftUI

struct FloatingNextButtonView: View {
    var body: some View {
        VStack {
            Spacer()
            Button(action: {}) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .background(Color("BrandLightGreen"))
                    Text("Hello")
                }
            }
        }
    }
}

struct FloatingNextButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingNextButtonView()
    }
}
