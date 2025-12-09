//
//  User.swift
//  Thoughts
//
//  Model for a user
//

import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) var id: UUID
    var email: String
    var passwordHash: String
    var name: String
    
    init(
        id: UUID = UUID(),
        email: String,
        passwordHash: String,
        name: String
    ) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
        self.name = name
    }
    
    var initials: String {
        String(name.prefix(1)).uppercased()
    }
    
    var firstName: String {
        name.components(separatedBy: " ").first ?? name
    }
}
