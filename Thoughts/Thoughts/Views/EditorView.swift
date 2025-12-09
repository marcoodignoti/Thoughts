//
//  EditorView.swift
//  Thoughts
//
//  Note editor view with auto-save functionality
//

import SwiftUI
import SwiftData

struct EditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: AppViewModel
    
    var noteId: UUID?
    var notebookId: UUID?
    var userId: UUID
    var initialContent: String
    var notebookName: String?
    var isNew: Bool
    
    @State private var content: String = ""
    @State private var isSaving: Bool = false
    @State private var saveError: Bool = false
    @State private var saveTask: Task<Void, Never>?
    
    var body: some View {
        ZStack {
            Color.paper.opacity(0.9)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Text Editor
                TextEditor(text: $content)
                    .font(.system(.title3, design: .monospaced))
                    .foregroundColor(.ink)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
            }
            
            // Save Error Alert
            if saveError {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Unable to save. Please try again.")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.ink)
                        Spacer()
                        Button("Retry") {
                            saveError = false
                            saveNote()
                        }
                        .font(.subheadline.weight(.bold))
                        .foregroundColor(.blue)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.orange.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: saveError)
        .onAppear {
            content = initialContent
        }
        .onChange(of: content) { oldValue, newValue in
            scheduleSave()
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: handleGoBack) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.body.weight(.medium))
                    Text("Back")
                        .font(.body.weight(.medium))
                }
                .foregroundColor(.ink.opacity(0.6))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.black.opacity(0.05))
                .clipShape(Capsule())
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(notebookName ?? "Thought")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.ink.opacity(0.4))
                    .textCase(.uppercase)
                    .tracking(1)
                
                if isSaving {
                    Text("Saving...")
                        .font(.caption2.weight(.medium))
                        .foregroundColor(.ink.opacity(0.2))
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 56)
        .padding(.bottom, 16)
    }
    
    private func scheduleSave() {
        saveTask?.cancel()
        
        saveTask = Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                saveNote()
            }
        }
    }
    
    private func saveNote() {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !isNew else { return }
        
        isSaving = true
        saveError = false
        
        if let noteId = noteId {
            // Update existing note
            let descriptor = FetchDescriptor<Note>(predicate: #Predicate { $0.id == noteId })
            if let existingNote = try? modelContext.fetch(descriptor).first {
                existingNote.content = content
                existingNote.updatedAt = Date()
            }
        } else if !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // Create new note
            let newNote = Note(
                userId: userId,
                content: content,
                notebookId: notebookId
            )
            modelContext.insert(newNote)
        }
        
        do {
            try modelContext.save()
        } catch {
            // Show error indicator to user
            saveError = true
        }
        
        isSaving = false
    }
    
    private func handleGoBack() {
        saveTask?.cancel()
        
        // Save before leaving if content changed
        if content != initialContent {
            saveNote()
        }
        
        viewModel.closeEditor(notebookId: notebookId)
    }
}

#Preview {
    EditorView(
        viewModel: AppViewModel(),
        noteId: nil,
        notebookId: nil,
        userId: UUID(),
        initialContent: "",
        notebookName: nil,
        isNew: true
    )
    .modelContainer(for: Note.self, inMemory: true)
}
