//
//  TabBarView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/15/22.
//

import SwiftUI

struct TabBarView: View {
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @State private var firstCircle = 1.0
    @State private var secondCircle = 1.0
    
    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
            }
        }
        .padding(.top, 10)
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabBarView_Previews: PreviewProvider {
    
    static let tabs: [TabBarItem] = [
        .feed, .post, .map
    ]
    
    static var previews: some View {
        VStack {
            Spacer()
            TabBarView(tabs: tabs, selection: .constant(tabs.first!))
        }.background(Color("LightText"))
    }
}

extension TabBarView {
    
    private func tabView(tab: TabBarItem) -> some View {
        Button(action: {
            switchToTab(tab: tab)
            let impactMed = UIImpactFeedbackGenerator(style: .light)
            impactMed.impactOccurred()
        }) {
            ZStack {
                if tab == .post {
                    ZStack {
                        Circle()
                            .foregroundColor(Color("BrandDarkGreen"))
                            .frame(width: 60, height: 60)
                            .shadow(color: Color("BrandDarkGreen"), radius: 20, x: 0, y: 6)
                        Image(tab.imageName)
                            .blending(color: Color.white)
                            .frame(width: 30, height: 30)
                    }
                } else {
                    Image(tab.imageName)
                        .blending(color: (selection == tab ? Color("BrandDarkGrey") : Color("BrandLightGrey")))
                        .frame(width: 30, height: 30)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }
}
