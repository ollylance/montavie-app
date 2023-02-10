//
//  MainView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/16/22.
//

import SwiftUI
import FirebaseAuth

struct MainViewSignedIn: View {
    @State var tabSelection: TabBarItem = .feed
    @State var oldTabSelection: TabBarItem = .feed
    @State var isPostPresenting = false
    @StateObject var helpData = HelpData()
    @StateObject var feedData = FeedData()
    @StateObject var profileData = ProfileData()
    
    var body: some View {
        TabBarContainerView(selection: $tabSelection) {
            FeedView(feedData: feedData)
                .tabBarItem(tab: .feed, selection: $tabSelection)
            
            Text("")
                .tabBarItem(tab: .post, selection: $tabSelection)
            
            HelpView(tabSelection: $tabSelection, helpData: helpData)
                .task {
                    helpData.load()
                }
                .onChange(of: helpData.entries) { _ in
                    helpData.save()
                }
                .tabBarItem(tab: .help, selection: $tabSelection)
        }
        .fullScreenCover(isPresented: $isPostPresenting, onDismiss: {
                self.tabSelection = self.oldTabSelection
            }) {
            NewPostView(tabSelection: $tabSelection)
        }
        .onChange(of: tabSelection) { _ in
            if .post == tabSelection {
                self.isPostPresenting = true
            } else {
                tabSelection = tabSelection
                self.oldTabSelection = tabSelection
            }
        }
        .onAppear {
            if Auth.auth().currentUser != nil {
                feedData.fetchData()
            }
        }
    }
}

struct MainViewSignedIn_Previews: PreviewProvider {
    static var previews: some View {
        MainViewSignedIn()
    }
}
