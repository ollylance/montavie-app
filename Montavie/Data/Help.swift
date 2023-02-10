//
//  Help.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 12/12/22.
//
import SwiftUI

struct Help: Identifiable, Equatable, Hashable, Codable {
    var id = UUID()
    var title = ""
    var text : String = ""
    var unlocked: Bool = false
    var imageName: String = "RelaxingBackground1"
}
