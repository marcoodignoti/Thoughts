//
//  BottomBar.swift
//  Thoughts
//
//  Bottom navigation bar with glass aesthetic
//

import SwiftUI

enum TabType {
    case home
    case notes
    case settings
    case search
}

struct BottomBar: View {
    var activeTab: TabType
    var onHome: () -> Void
    var onNewNote: () -> Void
    var onSettings: () -> Void
    var onSearch: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 12) {
                // Main Dock
                HStack(spacing: 4) {
                    BarButton(
                        icon: "house",
                        accessibilityLabel: "Home",
                        isActive: activeTab == .home,
                        isPrimary: false,
                        action: onHome
                    )
                    
                    Divider()
                        .frame(height: 24)
                        .padding(.horizontal, 4)
                    
                    BarButton(
                        icon: "pencil.line",
                        accessibilityLabel: "Create new note",
                        isActive: activeTab == .notes,
                        isPrimary: true,
                        action: onNewNote
                    )
                    
                    Divider()
                        .frame(height: 24)
                        .padding(.horizontal, 4)
                    
                    BarButton(
                        icon: "gearshape",
                        accessibilityLabel: "Settings",
                        isActive: activeTab == .settings,
                        isPrimary: false,
                        action: onSettings
                    )
                }
                .padding(8)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.08), radius: 20, y: 10)
                )
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
                
                // Search Button
                Button(action: onSearch) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 60, height: 60)
                            .shadow(color: .black.opacity(0.08), radius: 10, y: 5)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
                            )
                        
                        Image(systemName: "magnifyingglass")
                            .font(.title3.weight(.medium))
                            .foregroundColor(activeTab == .search ? .ink : .ink.opacity(0.7))
                    }
                }
                .buttonStyle(ScaleButtonStyle())
                .accessibilityLabel("Search")
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
}

struct BarButton: View {
    var icon: String
    var accessibilityLabel: String
    var isActive: Bool
    var isPrimary: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isPrimary {
                    Circle()
                        .fill(Color.ink)
                        .frame(width: 56, height: 56)
                        .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
                    
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
                    
                    Image(systemName: icon)
                        .font(.title3.weight(.medium))
                        .foregroundColor(.paper)
                } else {
                    Circle()
                        .fill(isActive ? Color.black.opacity(0.1) : Color.clear)
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.title3.weight(.medium))
                        .foregroundColor(isActive ? .ink : .ink.opacity(0.6))
                }
            }
        }
        .buttonStyle(ScaleButtonStyle())
        .accessibilityLabel(accessibilityLabel)
    }
}

#Preview {
    ZStack {
        Color.paper.ignoresSafeArea()
        BottomBar(
            activeTab: .home,
            onHome: {},
            onNewNote: {},
            onSettings: {},
            onSearch: {}
        )
    }
}
