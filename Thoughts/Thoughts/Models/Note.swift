//
//  Note.swift
//  Thoughts
//
//  Model for a note/thought
//

import Foundation
import SwiftData

@Model
final class Note {
    @Attribute(.unique) var id: UUID
    var userId: UUID
    var content: String
    var notebookId: UUID?
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        userId: UUID,
        content: String = "",
        notebookId: UUID? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.content = content
        self.notebookId = notebookId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var previewText: String {
        if content.isEmpty {
            return "Empty thought..."
        }
        return String(content.prefix(100))
    }
    
    // Bolt: Cache DateFormatter to avoid expensive recreation for each note (O(N) -> O(1) instantiation)
    // This significantly improves scrolling performance in lists with many notes.
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()

    var formattedDate: String {
        return Self.dateFormatter.string(from: updatedAt)
    }
}
