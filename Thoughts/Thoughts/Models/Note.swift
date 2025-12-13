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
    
    // Cache the DateFormatter to avoid expensive initialization on every access
    private static let noteDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()

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
    
    var formattedDate: String {
        return Self.noteDateFormatter.string(from: updatedAt)
    }
}
