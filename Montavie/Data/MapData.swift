//
//  MapData.swift
//  Montavie
//
//  Created by Oliver Lance on 2/3/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import PhotosUI
import MapKit

class MapData: ObservableObject {
    @Published var mapData = [Post]()
    @Published var selectedLocation: Post? = nil
//    [Post(location: CLLocationCoordinate2D(latitude: 40.15018658897445, longitude: -77.12687838584033))]
    @State var isFetchInProgress = false
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.15018658897445, longitude: -77.12687838584033),
        span: MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 30))
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    private var db = Firestore.firestore()
    
    func selectLocation(post: Post?) {
        withAnimation(.easeInOut) {
            selectedLocation = post
        }
        if selectedLocation != nil && selectedLocation!.location != nil {
            updateMapRegion(post: selectedLocation!)
        }
    }
    
    func selectLocationFromCoordinate(coordinate: CLLocationCoordinate2D?) {
        if coordinate != nil {
            guard let currentIndex = mapData.firstIndex(where: {
                return $0.location == coordinate
                
            }) else {
                return
            }
            selectLocation(post: mapData[(currentIndex)])
        }
    }
    
    func updateMapRegion(post: Post) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(center: post.location!, span: mapSpan)
        }
    }
    
    
    func nextLocation() {
        if selectedLocation != nil {
            guard let currentIndex = mapData.firstIndex(where: {$0 == selectedLocation}) else {
                return
            }
            selectLocation(post: mapData[(currentIndex+1) % mapData.count])
        }
    }
    
    func prevLocation() {
        if selectedLocation != nil {
            guard var currentIndex = mapData.firstIndex(where: {$0 == selectedLocation}) else {
                return
            }
            currentIndex = currentIndex-1 < 0 ? mapData.count-1 : currentIndex-1
            selectLocation(post: mapData[(currentIndex) % mapData.count])
        }
    }
    
    func fetchData() {
        db.collection("posts").order(by: "date").getDocuments { (snap, err) in
            guard let documents = snap?.documents else {
                return
            }
            
            let data = documents.map { (queryDocumentSnapshot) -> Post in
                let data = queryDocumentSnapshot.data()
                let key = queryDocumentSnapshot.documentID
                let timestamp = data["date"] as? Timestamp
                let text = data["text"] as? String
                let color = data["color"] as? String
                let imageURL = data["imageURL"] as? String
                let size = data["size"] as? String
                let uid = data["uid"] as? String
                let lat = data["lat"] as? Double
                let lng = data["lng"] as? Double
                var location: CLLocationCoordinate2D? = nil
                if (lat != nil && lng != nil && lat != 0.0 && lng != 0.0) {
                    location = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
                }
                return Post(date: timestamp!.dateValue(),
                             color: color!,
                             text: text!,
                             size: size ?? "landscape",
                             imageURL: imageURL!,
                             uid: uid ?? "",
                             key: key,
                             location: location)
            }
            self.mapData = data.filter {$0.location != nil}
        }
    }
}
