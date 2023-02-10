//
//  Map.swift
//  Montavie
//
//  Created by Oliver Lance on 2/3/23.
//

import SwiftUI
import PhotosUI

struct MapValue: Identifiable, Equatable, Hashable {
    var id: UUID = UUID()
    var date : Date = Date()
    var color : String = "BrandLightGrey"
    var text: String = ""
    var uid: String = ""
    var key: String = ""
    var location: CLLocationCoordinate2D? = nil
}
