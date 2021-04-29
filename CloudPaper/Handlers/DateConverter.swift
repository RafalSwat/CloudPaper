//
//  DateConverter.swift
//  CloudPaper
//
//  Created by Rafał Swat on 29/04/2021.
//

import Foundation

class DateConverter {
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }()
    static func convertFromString(dateString: String) -> Date {
        if let dateTypeDate = dateFormat.date(from: dateString) {
            return dateTypeDate
        } else {
            print("Error: Data Converter Error: finds nil during converting String --> Date! - .default format")
            return Date()
        }
    }
}
