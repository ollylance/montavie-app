//
//  DateFunctions.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/16/22.
//

import Foundation

func getFormattedDate(format: String, date: Date) -> String {
    let dateformat = DateFormatter()
    dateformat.dateFormat = format
    dateformat.amSymbol = "AM"
    dateformat.pmSymbol = "PM"
    return dateformat.string(from: date)
}
