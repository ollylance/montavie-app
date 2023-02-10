//
//  RouteView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/24/22.
//

import SwiftUI

struct RouteView: View {
    @ObservedObject var session : SessionAuth
    
    func listen() {
        session.listenAuthentificationState()
    }
    
    var body: some View {
        Group {
            if session.isLoggedIn != nil {
                MainView(session: session)
                    .ignoresSafeArea(.keyboard)
            }
            else {
                LogoView()
            }
        }.onAppear(perform: listen)
    }
}

struct RouteView_Previews: PreviewProvider {
    static var previews: some View {
        RouteView(session: SessionAuth())
    }
}
