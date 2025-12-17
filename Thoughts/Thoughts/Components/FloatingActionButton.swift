//
//  FloatingActionButton.swift
//  Thoughts
//
//  Floating action button component
//

import SwiftUI

struct FloatingActionButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.ink)
                    .frame(width: 56, height: 56)
                    .shadow(color: .black.opacity(0.2), radius: 15, y: 5)
                
                // Gloss overlay
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.2), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                
                Image(systemName: "plus")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.paper)
            }
        }
        .buttonStyle(ScaleButtonStyle())
        .accessibilityLabel("Create new note")
    }
}

#Preview {
    FloatingActionButton(action: {})
}
