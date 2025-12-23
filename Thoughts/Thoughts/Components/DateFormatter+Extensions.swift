//
//  DateFormatter+Extensions.swift
//  Thoughts
//
//  Shared DateFormatter instances to improve performance
//

import Foundation

extension DateFormatter {
    static let homeDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()
}
