//
//  DateFormatter+Extensions.swift
//  Thoughts
//
//  Shared DateFormatter instances for performance optimization
//

import Foundation

extension DateFormatter {
    /// Cached date formatter for the Home screen header (e.g., "Monday, May 22")
    static let homeDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()
}
