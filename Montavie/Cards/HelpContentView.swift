//
//  HelpContentView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 12/12/22.
//

import SwiftUI

struct HelpContentView: View {
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ZStack {
                        Image(data.imageName)
                            .resizable()
                            .matchedGeometryEffect(id: data.id.uuidString + "helpImage", in: namespace)
                            .mask(RoundedRectangle(cornerRadius: 20).matchedGeometryEffect(id: data.id.uuidString + "clipmask", in: namespace))
                            .padding(.bottom, 30)
                            .frame(height: 300)
                        HStack {
                            Text(data.title)
                                .font(.system(size: 32,
                                              weight: .bold,
                                              design: .rounded))
                                .foregroundColor(Color.white)
                                .matchedGeometryEffect(id: data.id.uuidString + "text", in: namespace)
                                .padding(.leading, 50)
                            Spacer()
                        }
                        .padding(.top, 75)
                    }
                    .frame(height: 150)
                    
                    Text(data.text)
                        .font(.system(size: 30,
                                      weight: .light,
                                      design: .rounded))
                        .opacity(100)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .padding(.top, 30)
                }
            }
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
        .background(Color.white)
    }
}

struct HelpContentView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        HelpContentView(data: .constant(Help(text: "Hello")), show: .constant(true), namespace: namespace)
    }
}
