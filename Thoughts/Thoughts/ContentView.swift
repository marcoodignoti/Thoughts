//
//  ContentView.swift
//  Thoughts
//
//  Main content view that handles navigation between app states
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = AppViewModel()
    
    @Query private var users: [User]
    @Query private var notes: [Note]
    @Query private var notebooks: [Notebook]
    
    var body: some View {
        ZStack {
            Color.paper
                .ignoresSafeArea()
            
            switch viewModel.appStatus {
            case .loading:
                Color.paper
                
            case .onboarding:
                OnboardingView(viewModel: viewModel)
                    .transition(.opacity)
                
            case .auth:
                AuthView(viewModel: viewModel)
                    .transition(.opacity)
                
            case .app:
                if let user = viewModel.currentUser ?? fetchCurrentUser() {
                    mainAppView(user: user)
                } else {
                    // No user found, go back to onboarding
                    Color.paper
                        .onAppear {
                            viewModel.appStatus = .onboarding
                        }
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: viewModel.appStatus)
    }
    
    private func fetchCurrentUser() -> User? {
        if let userId = viewModel.getSavedUserId() {
            let user = users.first { $0.id == userId }
            if let user = user {
                viewModel.currentUser = user
            }
            return user
        }
        return nil
    }
    
    @ViewBuilder
    private func mainAppView(user: User) -> some View {
        let userNotes = notes.filter { $0.userId == user.id }
        let userNotebooks = notebooks.filter { $0.userId == user.id }
        
        ZStack {
            switch viewModel.viewState {
            case .home:
                HomeView(
                    viewModel: viewModel,
                    user: user,
                    notes: userNotes,
                    notebooks: userNotebooks
                )
                .transition(.opacity)
                
            case .notebook(let notebookId):
                if let notebook = userNotebooks.first(where: { $0.id == notebookId }) {
                    NotebookDetailView(
                        viewModel: viewModel,
                        notebook: notebook,
                        notes: userNotes.filter { $0.notebookId == notebookId }
                    )
                    .transition(.move(edge: .trailing))
                }
                
            case .editor(let noteId, let notebookId, let isNew):
                EditorView(
                    viewModel: viewModel,
                    noteId: noteId,
                    notebookId: notebookId,
                    userId: user.id,
                    initialContent: noteId.flatMap { id in userNotes.first { $0.id == id }?.content } ?? "",
                    notebookName: notebookId.flatMap { id in userNotebooks.first { $0.id == id }?.name },
                    isNew: isNew
                )
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
            
            // Search Overlay
            if viewModel.isSearchOpen {
                SearchOverlay(
                    viewModel: viewModel,
                    notes: userNotes
                )
                .transition(.opacity)
            }
            
            // Settings Modal
            if viewModel.isSettingsOpen {
                SettingsModal(
                    viewModel: viewModel,
                    user: user
                )
                .transition(.scale.combined(with: .opacity))
            }
            
            // New Notebook Modal
            if viewModel.isNotebookModalOpen {
                NewNotebookModal(
                    viewModel: viewModel,
                    userId: user.id
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.viewState)
        .animation(.easeInOut(duration: 0.3), value: viewModel.isSearchOpen)
        .animation(.easeInOut(duration: 0.3), value: viewModel.isSettingsOpen)
        .animation(.easeInOut(duration: 0.3), value: viewModel.isNotebookModalOpen)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Note.self, Notebook.self, User.self], inMemory: true)
}
