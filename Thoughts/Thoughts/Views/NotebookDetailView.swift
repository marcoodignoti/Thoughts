//
//  NotebookDetailView.swift
//  Thoughts
//
//  Detail view for a specific notebook showing its notes
//

import SwiftUI
import SwiftData

struct NotebookDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: AppViewModel
    var notebook: Notebook
    var notes: [Note]
    
    private var sortedNotes: [Note] {
        // Notes are already sorted by the Query in ContentView
        notes
    }
    
    var body: some View {
        ZStack {
            Color.paper.opacity(0.9)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Notes List
                if sortedNotes.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(sortedNotes) { note in
                                NoteCard(note: note) {
                                    viewModel.openNote(id: note.id, notebookId: notebook.id)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        .padding(.bottom, 100)
                    }
                }
            }
            
            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButton {
                        viewModel.createNote()
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 32)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: { viewModel.navigateHome() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.body.weight(.medium))
                        Text("Home")
                            .font(.body.weight(.medium))
                    }
                    .foregroundColor(.ink.opacity(0.6))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.black.opacity(0.05))
                    .clipShape(Capsule())
                }
                Spacer()
            }
            
            Text(notebook.name)
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.ink)
            
            Text("\(notes.count) thoughts")
                .font(.subheadline.weight(.medium))
                .foregroundColor(.ink.opacity(0.4))
        }
        .padding(.horizontal, 24)
        .padding(.top, 56)
        .padding(.bottom, 16)
        .background(Color.clear)
        .overlay(
            Rectangle()
                .fill(Color.black.opacity(0.05))
                .frame(height: 1),
            alignment: .bottom
        )
    }
    
    private var emptyState: some View {
        VStack {
            Spacer()
            Text("This notebook is empty.")
                .font(.subheadline)
                .foregroundColor(.ink.opacity(0.3))
            Spacer()
        }
    }
}

#Preview {
    NotebookDetailView(
        viewModel: AppViewModel(),
        notebook: Notebook(userId: UUID(), name: "Test Notebook"),
        notes: []
    )
}
