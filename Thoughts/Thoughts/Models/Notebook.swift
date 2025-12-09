//
//  Notebook.swift
//  Thoughts
//
//  Model for a notebook (collection of notes)
//

import Foundation
import SwiftData

@Model
final class Notebook {
    @Attribute(.unique) var id: UUID
    var userId: UUID
    var name: String
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        userId: UUID,
        name: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.name = name
        self.createdAt = createdAt
    }
}
