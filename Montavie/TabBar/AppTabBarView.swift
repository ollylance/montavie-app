//
//  AppTabBarView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/15/22.
//

import SwiftUI

struct AppTabBarView: View {
    @State var tabSelection: TabBarItem = .feed
    
    var body: some View {
        TabBarContainerView(selection: $tabSelection) {
            Color.blue
                .tabBarItem(tab: .feed, selection: $tabSelection)
            Color.red
                .tabBarItem(tab: .post, selection: $tabSelection)
            Color.blue
                .tabBarItem(tab: .map, selection: $tabSelection)
        }
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabBarView()
    }
}
