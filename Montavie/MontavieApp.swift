//
//  RainyDayLoverApp.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/12/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI
import SDWebImagePhotosPlugin
import SDWebImage

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        setupAndMigrateFirebaseAuth()
        do {
            try Auth.auth().useUserAccessGroup("\(teamID).honeysuckle.Montavie")
        } catch let error as NSError {
            print("Error changing user access group: %@", error)
        }
        
        let settings = Firestore.firestore().settings
        settings.isPersistenceEnabled = true
        Firestore.firestore().settings = settings
        
        // Add default HTTP header
        SDWebImageDownloader.shared.setValue("image/webp,image/apng,image/*,*/*;q=0.8", forHTTPHeaderField: "Accept")
        
        // Add multiple caches
        let cache = SDImageCache(namespace: "tiny")
        cache.config.maxMemoryCost = 200 * 1024 * 1024 // 200MB memory
        cache.config.maxDiskSize = 100 * 1024 * 1024 // 100MB disk
        SDImageCachesManager.shared.addCache(cache)
        SDWebImageManager.defaultImageCache = SDImageCachesManager.shared
        
        // Add multiple loaders with Photos Asset support
        SDImageLoadersManager.shared.addLoader(SDImagePhotosLoader.shared)
        SDWebImageManager.defaultImageLoader = SDImageLoadersManager.shared
        return true
    }
}

@main
struct MontavieApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RouteView(session: SessionAuth())
       }
    }
}
