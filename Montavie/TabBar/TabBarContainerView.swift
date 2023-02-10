//
//  TabBarContainerView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/15/22.
//

import SwiftUI

struct TabBarContainerView<Content: View>: View {
    
    @Binding var selection: TabBarItem
    @State private var tabs: [TabBarItem] = []
    let content: Content
    
    public init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                content
            }
            TabBarView(tabs: tabs, selection: $selection)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: {value in
            self.tabs = value
        })
    }
}

struct TabBarContainerView_Previews: PreviewProvider {
    static let tabs: [TabBarItem] = [
        .post, .feed
    ]
    
    static var previews: some View {
        TabBarContainerView(selection: .constant(tabs.first!)) {
            Color.red
        }
    }
}
