//
//  DateFormatter+Extensions.swift
//  Thoughts
//
//  Shared DateFormatter instances for performance optimization
//

import Foundation

extension DateFormatter {
    /// Shared formatter for the home screen date display
    /// Format: "EEEE, MMMM d" (e.g., "Monday, January 1")
    static let homeDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()
}
