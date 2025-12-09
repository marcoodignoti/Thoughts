//
//  OnboardingView.swift
//  Thoughts
//
//  Onboarding flow for new users
//

import SwiftUI

struct OnboardingView: View {
    @Bindable var viewModel: AppViewModel
    @State private var step: Int = 0
    @State private var name: String = ""
    @State private var isExiting = false
    
    var body: some View {
        ZStack {
            // Background
            Color.paper
                .ignoresSafeArea()
            
            // Ambient background blobs
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
                .blur(radius: 120)
                .offset(x: -UIScreen.main.bounds.width * 0.2, y: -UIScreen.main.bounds.height * 0.2)
            
            Circle()
                .fill(Color.orange.opacity(0.1))
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
                .blur(radius: 120)
                .offset(x: UIScreen.main.bounds.width * 0.2, y: UIScreen.main.bounds.height * 0.2)
            
            VStack {
                Spacer()
                
                // Content
                VStack(alignment: .leading, spacing: 24) {
                    if step == 0 {
                        welcomeStep
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    } else {
                        nameStep
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 32)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: step)
                
                Spacer()
                
                // Bottom buttons
                HStack {
                    if step == 0 {
                        Button("I have an account") {
                            viewModel.skipToLogin()
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.ink.opacity(0.4))
                    }
                    
                    Spacer()
                    
                    Button(action: handleNext) {
                        ZStack {
                            Circle()
                                .fill(Color.ink)
                                .frame(width: 64, height: 64)
                                .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.paper)
                        }
                    }
                    .disabled(step == 1 && name.trimmingCharacters(in: .whitespaces).isEmpty)
                    .opacity(step == 1 && name.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
        .opacity(isExiting ? 0 : 1)
        .animation(.easeOut(duration: 0.5), value: isExiting)
    }
    
    private var welcomeStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Capture your\n")
                .font(.system(size: 44, weight: .bold))
                .foregroundColor(.ink)
            +
            Text("mind.")
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .indigo],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text("A quiet place for your thoughts, ideas, and notebooks.")
                .font(.title3.weight(.medium))
                .foregroundColor(.ink.opacity(0.6))
                .lineSpacing(4)
        }
    }
    
    private var nameStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("LET'S GET INTRODUCED")
                .font(.caption.weight(.bold))
                .foregroundColor(.ink.opacity(0.4))
                .tracking(2)
            
            Text("What should we call you?")
                .font(.title.weight(.bold))
                .foregroundColor(.ink)
            
            TextField("Your Name", text: $name)
                .font(.largeTitle.weight(.medium))
                .foregroundColor(.ink)
                .padding(.bottom, 16)
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(name.isEmpty ? .ink.opacity(0.1) : .ink),
                    alignment: .bottom
                )
                .onSubmit(handleNext)
        }
    }
    
    private func handleNext() {
        if step == 0 {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                step = 1
            }
        } else {
            guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            isExiting = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.completeOnboarding(name: name)
            }
        }
    }
}

#Preview {
    OnboardingView(viewModel: AppViewModel())
}
