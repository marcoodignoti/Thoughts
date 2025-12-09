//
//  SettingsModal.swift
//  Thoughts
//
//  Settings modal with user info and logout
//

import SwiftUI

struct SettingsModal: View {
    @Bindable var viewModel: AppViewModel
    var user: User
    
    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.2)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
                .onTapGesture {
                    viewModel.isSettingsOpen = false
                }
            
            // Modal Card
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("Settings")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.ink)
                    
                    Spacer()
                    
                    Button(action: { viewModel.isSettingsOpen = false }) {
                        Image(systemName: "xmark")
                            .font(.body.weight(.medium))
                            .foregroundColor(.ink.opacity(0.6))
                            .padding(10)
                            .background(Color.black.opacity(0.05))
                            .clipShape(Circle())
                    }
                }
                
                // User Card
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.ink)
                            .frame(width: 48, height: 48)
                        
                        Text(user.initials)
                            .font(.headline.weight(.bold))
                            .foregroundColor(.paper)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(user.name)
                            .font(.headline.weight(.bold))
                            .foregroundColor(.ink)
                            .lineLimit(1)
                        
                        Text(user.email)
                            .font(.caption)
                            .foregroundColor(.ink.opacity(0.5))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black.opacity(0.05), lineWidth: 1)
                        )
                )
                
                // Actions
                VStack(spacing: 8) {
                    SettingsRow(icon: "person", title: "Account Details", isDisabled: true)
                    SettingsRow(icon: "envelope", title: "Email Preferences", isDisabled: true)
                }
                
                Spacer().frame(height: 8)
                
                // Logout Button
                Button(action: {
                    viewModel.logout()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.body.weight(.medium))
                        
                        Text("Sign Out")
                            .font(.subheadline.weight(.medium))
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.red.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.red.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
                
                // Version
                Text("Thoughts v1.1")
                    .font(.caption2)
                    .foregroundColor(.ink.opacity(0.2))
                    .textCase(.uppercase)
                    .tracking(2)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.paper.opacity(0.9))
                    .shadow(color: .black.opacity(0.1), radius: 30, y: 10)
            )
            .padding(.horizontal, 24)
        }
    }
}

struct SettingsRow: View {
    var icon: String
    var title: String
    var isDisabled: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body.weight(.medium))
            
            Text(title)
                .font(.subheadline.weight(.medium))
            
            Spacer()
        }
        .foregroundColor(isDisabled ? .ink.opacity(0.4) : .ink)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
        )
        .opacity(isDisabled ? 0.6 : 1)
    }
}

#Preview {
    SettingsModal(
        viewModel: AppViewModel(),
        user: User(email: "test@test.com", passwordHash: "test", name: "John Doe")
    )
}
