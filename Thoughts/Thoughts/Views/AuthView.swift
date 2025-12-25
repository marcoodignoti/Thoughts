//
//  AuthView.swift
//  Thoughts
//
//  Authentication screen for login/register
//

import SwiftUI
import SwiftData
import CryptoKit
import Foundation

struct AuthView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @Bindable var viewModel: AppViewModel
    
    @State private var isLogin: Bool = true
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            // Background
            Color.paper
                .ignoresSafeArea()
            
            // Ambient background blobs
            Circle()
                .fill(Color.blue.opacity(0.05))
                .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.width * 0.6)
                .blur(radius: 100)
                .offset(x: -UIScreen.main.bounds.width * 0.1, y: -UIScreen.main.bounds.height * 0.1)
            
            Circle()
                .fill(Color.orange.opacity(0.08))
                .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.width * 0.6)
                .blur(radius: 100)
                .offset(x: UIScreen.main.bounds.width * 0.1, y: UIScreen.main.bounds.height * 0.1)
            
            VStack {
                // Back button
                if !viewModel.onboardingName.isEmpty {
                    HStack {
                        Button(action: { viewModel.appStatus = .onboarding }) {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(.ink.opacity(0.6))
                                .padding(12)
                                .background(Color.black.opacity(0.05))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 48)
                }
                
                Spacer()
                
                // Auth Card
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text(!viewModel.onboardingName.isEmpty ? "Hi, \(viewModel.onboardingName)." : "thoughts.")
                            .font(.largeTitle.weight(.bold))
                            .foregroundColor(.ink)
                        
                        Text(isLogin ? "Welcome back." : "Create your private space.")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.ink.opacity(0.5))
                    }
                    
                    // Form
                    VStack(spacing: 16) {
                        if !isLogin && viewModel.onboardingName.isEmpty {
                            TextField("Your Name", text: $name)
                                .textFieldStyle(GlassTextFieldStyle())
                        }
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(GlassTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(GlassTextFieldStyle())
                            .textContentType(isLogin ? .password : .newPassword)
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.caption.weight(.medium))
                                .foregroundColor(.red)
                        }
                        
                        Button(action: handleSubmit) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.ink)
                                    .frame(height: 56)
                                
                                if isLoading {
                                    ProgressView()
                                        .tint(.paper)
                                } else {
                                    Text(isLogin ? "Sign In" : "Create Account")
                                        .font(.headline.weight(.bold))
                                        .foregroundColor(.paper)
                                }
                            }
                        }
                        .disabled(isLoading)
                        .padding(.top, 8)
                    }
                    
                    // Toggle auth mode
                    Button(action: toggleMode) {
                        Text(isLogin ? "New here? Create account" : "Already have an account? Sign in")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.ink.opacity(0.4))
                    }
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: 32)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.05), radius: 20, y: 10)
                )
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .onAppear {
            if !viewModel.onboardingName.isEmpty {
                isLogin = false
                name = viewModel.onboardingName
            }
        }
    }
    
    private func toggleMode() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isLogin.toggle()
            errorMessage = ""
        }
    }
    
    private func handleSubmit() {
        errorMessage = ""
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if isLogin {
                performLogin()
            } else {
                performRegister()
            }
            isLoading = false
        }
    }
    
    private func performLogin() {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let hashed = hashPassword(password)

        // 1. Try secure login
        if let user = users.first(where: { $0.email == cleanEmail && $0.passwordHash == hashed }) {
            viewModel.login(user: user)
            return
        }

        // 2. Legacy fallback (Lazy Migration)
        if let user = users.first(where: { $0.email == cleanEmail && $0.passwordHash == password }) {
            user.passwordHash = hashed
            try? modelContext.save()
            viewModel.login(user: user)
            return
        }

        errorMessage = "Invalid credentials"
    }
    
    private func performRegister() {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if !isValidEmail(cleanEmail) {
            errorMessage = "Invalid email format"
            return
        }

        if !isValidPassword(password) {
            errorMessage = "Password must be at least 8 characters"
            return
        }

        // Check if email already exists
        if users.contains(where: { $0.email == cleanEmail }) {
            errorMessage = "Email already in use"
            return
        }
        
        let finalName = name.isEmpty ? (viewModel.onboardingName.isEmpty ? "Writer" : viewModel.onboardingName) : name
        
        let newUser = User(
            email: cleanEmail,
            passwordHash: hashPassword(password),
            name: finalName
        )
        
        modelContext.insert(newUser)
        
        do {
            try modelContext.save()
            viewModel.login(user: newUser)
        } catch {
            // Provide user feedback for save failure
            errorMessage = "Unable to create account. Please try again."
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }

    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - Custom TextField Style

struct GlassTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black.opacity(0.05), lineWidth: 1)
                    )
            )
    }
}

#Preview {
    AuthView(viewModel: AppViewModel())
        .modelContainer(for: User.self, inMemory: true)
}
