//
//  HelpCardView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 12/12/22.
//

import SwiftUI

struct HelpCardView: View {
    @Binding var data: Help
    @Binding var show: Bool
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            Image(data.imageName)
                .resizable()
                .matchedGeometryEffect(id: data.id.uuidString + "helpImage", in: namespace)
                .mask(RoundedRectangle(cornerRadius: 20).matchedGeometryEffect(id: data.id.uuidString + "clipmask", in: namespace))
                .frame(height: 150)
                .padding([.leading, .trailing, .top])
                .padding(.bottom, 30)
                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
            HStack {
                Text(data.title)
                    .foregroundColor(Color.white)
                    .font(.system(size: 32,
                                  weight: .bold,
                                  design: .rounded))
                    .matchedGeometryEffect(id: data.id.uuidString + "text", in: namespace)
                    .padding(.leading, 40)
                Spacer()
            }
            .padding()
        }
        .frame(height: 150)
    }
}

struct HelpCardGhostView: View {
    var color = Color.clear
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .frame(height: 150)
                .padding([.leading, .trailing, .top])
                .padding(.bottom, 30)
            HStack {
                Text("hello")
                    .foregroundColor(color)
                    .font(.system(size: 40,
                                  weight: .medium,
                                  design: .rounded))
                    .padding(.leading, 50)
                Spacer()
            }
            .padding()
        }
        .frame(height: 150)
    }
}

struct HelpCardView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        HelpCardView(data: .constant(Help(title: "Overwhelmed")), show: .constant(true), namespace: namespace)
    }
}
