//
//  HomeView.swift
//  Thoughts
//
//  Main home view displaying notebooks and recent notes
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Bindable var viewModel: AppViewModel
    var user: User
    var notes: [Note]
    var notebooks: [Notebook]
    
    // Bolt: Cache DateFormatter to avoid expensive recreation (O(1) instantiation)
    private static let headerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()

    private var currentDate: String {
        return Self.headerDateFormatter.string(from: Date())
    }
    
    private var recentNotes: [Note] {
        notes.sorted { $0.updatedAt > $1.updatedAt }
    }
    
    var body: some View {
        ZStack {
            Color.paper
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    headerView
                    
                    // Notebooks Section
                    notebooksSection
                    
                    // Recent Thoughts Section
                    recentThoughtsSection
                    
                    // Bottom padding for navigation bar
                    Spacer().frame(height: 120)
                }
            }
            
            // Bottom Bar
            BottomBar(
                activeTab: getActiveTab(),
                onHome: {
                    // Scroll to top or refresh
                },
                onNewNote: {
                    viewModel.createNote()
                },
                onSettings: {
                    viewModel.isSettingsOpen = true
                },
                onSearch: {
                    viewModel.isSearchOpen = true
                }
            )
        }
    }
    
    private var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text(currentDate.uppercased())
                        .font(.caption2.weight(.bold))
                }
                .foregroundColor(.ink.opacity(0.4))
                .tracking(1)
                
                Text("Hello, \(user.firstName).")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.ink)
            }
            
            Spacer()
            
            // Avatar
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 40, height: 40)
                    .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                
                Text(user.initials)
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.ink.opacity(0.6))
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 60)
    }
    
    private var notebooksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Notebooks")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.ink)
                
                Spacer()
                
                Button(action: { viewModel.isNotebookModalOpen = true }) {
                    Image(systemName: "plus")
                        .font(.body.weight(.medium))
                        .foregroundColor(.ink.opacity(0.4))
                        .padding(8)
                        .background(Color.black.opacity(0.05))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // New Notebook Button
                    Button(action: { viewModel.isNotebookModalOpen = true }) {
                        VStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.title2)
                            Text("New")
                                .font(.caption.weight(.bold))
                        }
                        .foregroundColor(.ink.opacity(0.3))
                        .frame(width: 140, height: 180)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                                        .foregroundColor(.black.opacity(0.05))
                                )
                        )
                    }
                    
                    // Notebook Cards
                    ForEach(notebooks) { notebook in
                        NotebookCard(
                            notebook: notebook,
                            noteCount: notes.filter { $0.notebookId == notebook.id }.count,
                            action: { viewModel.openNotebook(id: notebook.id) }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            }
        }
    }
    
    private var recentThoughtsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Thoughts")
                .font(.headline.weight(.bold))
                .foregroundColor(.ink)
                .padding(.horizontal, 24)
            
            if recentNotes.isEmpty {
                emptyState
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(recentNotes.prefix(10))) { note in
                        NoteCard(note: note) {
                            viewModel.openNote(id: note.id)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 8) {
            Text("Tap the pencil to write your first thought.")
                .font(.subheadline)
                .foregroundColor(.ink.opacity(0.3))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                .foregroundColor(.black.opacity(0.05))
        )
        .padding(.horizontal, 24)
    }
    
    private func getActiveTab() -> TabType {
        if viewModel.isSearchOpen { return .search }
        if viewModel.isSettingsOpen { return .settings }
        return .home
    }
}

#Preview {
    HomeView(
        viewModel: AppViewModel(),
        user: User(email: "test@test.com", passwordHash: "test", name: "John Doe"),
        notes: [],
        notebooks: []
    )
    .modelContainer(for: [Note.self, Notebook.self, User.self], inMemory: true)
}
