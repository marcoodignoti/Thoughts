//
//  DateFormatter+Extensions.swift
//  Thoughts
//
//  Shared DateFormatter instances for performance optimization.
//  Creating DateFormatter is expensive, so we cache them.
//

import Foundation

extension DateFormatter {
    /// Cached formatter for "Tuesday, January 2" style dates
    /// Optimization: avoids creating a new DateFormatter on every view render
    static let homeDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()
}
