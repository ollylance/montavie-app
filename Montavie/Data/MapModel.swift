//
//  MapModel.swift
//  Montavie
//
//  Created by Oliver Lance on 2/3/23.
//

import Foundation

struct TrailData: Codable {
    var features: [Section]
}

struct Section: Codable {
    var geometry: Coordinates
}

struct Coordinates: Codable {
    var coordinates: [[[Double]]]
}
