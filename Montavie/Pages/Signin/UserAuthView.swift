//
//  UserAuthView.swift
//  Montavie
//
//  Created by Oliver Lance on 2/5/23.
//

import SwiftUI

struct UserAuthView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var profileData: ProfileData
        
    var body: some View {
        switch viewRouter.currentPage {
        case .signUpPage:
            SignUpView(viewRouter: viewRouter, profileData: profileData)
        case .signInPage:
            SignInView(viewRouter: viewRouter, profileData: profileData)
        case .close:
            Text("")
                .onAppear{
                    self.presentationMode.wrappedValue.dismiss()
                }
        }
    }
}

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .signInPage
}

enum Page {
    case signUpPage
    case signInPage
    case close
}

struct UserAuthView_Previews: PreviewProvider {
    static var previews: some View {
        UserAuthView(viewRouter: ViewRouter(), profileData: ProfileData())
    }
}
