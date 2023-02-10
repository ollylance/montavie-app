//
//  MainView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/16/22.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @State var tabSelection: TabBarItem = .feed
    @State var oldTabSelection: TabBarItem = .feed

    @StateObject var feedData = FeedData()
    @StateObject var mapData = MapData()
    @StateObject var profileData = ProfileData()
    @ObservedObject var session : SessionAuth
    
    func listen() {
        session.listenAuthentificationState()
    }
    
    var body: some View {
        TabBarContainerView(selection: $tabSelection) {
            FeedView(feedData: feedData, profileData: profileData, sessionAuth: session)
                .tabBarItem(tab: .feed, selection: $tabSelection)
            
            MapView(tabSelection: $tabSelection, mapData: mapData, sessionAuth: session)
                .tabBarItem(tab: .map, selection: $tabSelection)
        }
        .onChange(of: tabSelection) { _ in
            tabSelection = tabSelection
            self.oldTabSelection = tabSelection
        }
        .onAppear {
            feedData.fetchData()
            mapData.fetchData()
            listen()
            if Auth.auth().currentUser != nil {
                profileData.fetchProfile()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(session: SessionAuth())
    }
}
