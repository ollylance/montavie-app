//
//  TabBarItem.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/15/22.
//

import Foundation
import SwiftUI

enum TabBarItem: Hashable {
    case feed, post, map
    
    var title: String {
        switch self {
        case .post: return "post"
        case .feed: return "feed"
        case .map: return "map"
        }
    }
    
    var imageName: String {
        switch self {
        case .post: return "PlusIcon"
        case .feed: return "HomeIcon"
        case .map: return "MapIcon"
        }
    }
    
//    var selectedColor: Color {
//        switch self {
//        case .post: return Color("BrandCoral")
//        case .feed: return Color("BrandDarkGreen")
//        }
//    }
}

