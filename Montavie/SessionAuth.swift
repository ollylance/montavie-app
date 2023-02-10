//
//  SessionAuth.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/24/22.
//

import FirebaseAuth

class SessionAuth : ObservableObject {
    @Published var isLoggedIn: Bool? = nil
    var handle : AuthStateDidChangeListenerHandle?
    
    func isUserLoggedIn() -> Bool {
        return isLoggedIn != nil && isLoggedIn!
    }
    
    func listenAuthentificationState() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                setupAndMigrateFirebaseAuth()
                self.isLoggedIn = true
            }
            else {
                self.isLoggedIn = false
            }
        })
    }
}

func setupAndMigrateFirebaseAuth() {
    let accessGroup = "\(teamID).honeysuckle.Montavie"
    guard Auth.auth().userAccessGroup != accessGroup else {
        print("Firebase Auth is already using the correct access group")
        return
    }
    print("Firebase Auth is not yet using correct access group. Migrating...")
    //for extension (widget) we want to share our auth status
    do {
        //get current user (so we can migrate later)
        let user = Auth.auth().currentUser
        //switch to using app group
        try Auth.auth().useUserAccessGroup(accessGroup)
        //migrate current user
        if let user = user {
            Auth.auth().updateCurrentUser(user) { error in
                if error == nil {
                    print("Firebase Auth user migrated")
                } else {
                    print("Auth.auth().updateCurrentUser error: \(error!)")
                }
            }
        }

    } catch let error {
        print("Auth.auth().useUserAccessGroup error: \(error)")
    }
    
}
