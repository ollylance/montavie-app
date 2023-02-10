//
//  Post.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/12/22.
//

import SwiftUI
import PhotosUI

struct Post: Identifiable, Equatable, Hashable {
    var id: UUID = UUID()
    var date : Date = Date()
    var color : String = "BrandLightGrey"
    var text: String = ""
    var size: String = "landscape"
    var imageURL: String = ""
    var imageData: Data? = nil
    var uid: String = ""
    var key: String = ""
    var location: CLLocationCoordinate2D? = nil
}

extension CLLocationCoordinate2D: Identifiable, Hashable, Equatable {
    public var id: Int {
        return hashValue
    }
    
    public func hash(into hasher: inout Hasher)  {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }

    public static func <(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.longitude < rhs.longitude
    }
}
