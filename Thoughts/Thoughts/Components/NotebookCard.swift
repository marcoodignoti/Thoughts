//
//  NotebookCard.swift
//  Thoughts
//
//  Reusable notebook card component
//

import SwiftUI

struct NotebookCard: View {
    var notebook: Notebook
    var noteCount: Int
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                // Background decoration
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .blur(radius: 20)
                    .offset(x: 16, y: -16)
                
                VStack(alignment: .leading, spacing: 0) {
                    Image(systemName: "folder")
                        .font(.title2.weight(.light))
                        .foregroundColor(.ink)
                    
                    Spacer()
                    
                    Text(notebook.name)
                        .font(.headline.weight(.bold))
                        .foregroundColor(.ink)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text("\(noteCount) \(noteCount == 1 ? "thought" : "thoughts")")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.ink.opacity(0.4))
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
            }
            .frame(width: 140, height: 180)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    NotebookCard(
        notebook: Notebook(userId: UUID(), name: "My Notebook"),
        noteCount: 5,
        action: {}
    )
}
