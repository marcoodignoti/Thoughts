//
//  NoteCard.swift
//  Thoughts
//
//  Reusable note card component
//

import SwiftUI

struct NoteCard: View {
    var note: Note
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Text(note.previewText)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.ink)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                Text(note.formattedDate)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.ink.opacity(0.4))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.4))
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black.opacity(0.05), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

#Preview {
    NoteCard(
        note: Note(userId: UUID(), content: "This is a sample note with some content that might be longer than usual to test truncation."),
        action: {}
    )
    .padding()
}
