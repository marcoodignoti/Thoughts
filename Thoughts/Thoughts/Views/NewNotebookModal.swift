//
//  NewNotebookModal.swift
//  Thoughts
//
//  Modal for creating a new notebook
//

import SwiftUI
import SwiftData

struct NewNotebookModal: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: AppViewModel
    var userId: UUID
    
    @State private var notebookName: String = ""
    @FocusState private var isNameFocused: Bool
    
    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.2)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
                .onTapGesture {
                    viewModel.isNotebookModalOpen = false
                }
            
            // Modal Card
            VStack(spacing: 24) {
                Text("New Notebook")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.ink)
                
                TextField("e.g. Artificial Intelligence", text: $notebookName)
                    .font(.body.weight(.medium))
                    .multilineTextAlignment(.center)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black.opacity(0.05))
                    )
                    .focused($isNameFocused)
                    .onSubmit(createNotebook)
                
                HStack(spacing: 12) {
                    Button(action: { viewModel.isNotebookModalOpen = false }) {
                        Text("Cancel")
                            .font(.body.weight(.medium))
                            .foregroundColor(.ink.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black.opacity(0.05))
                            )
                    }
                    
                    Button(action: createNotebook) {
                        Text("Create")
                            .font(.body.weight(.bold))
                            .foregroundColor(.paper)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.ink)
                                    .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
                            )
                    }
                    .disabled(notebookName.trimmingCharacters(in: .whitespaces).isEmpty)
                    .opacity(notebookName.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.white.opacity(0.8))
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .shadow(color: .black.opacity(0.1), radius: 30, y: 10)
            )
            .padding(.horizontal, 32)
        }
        .onAppear {
            isNameFocused = true
        }
    }
    
    private func createNotebook() {
        guard !notebookName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let notebook = Notebook(
            userId: userId,
            name: notebookName
        )
        
        modelContext.insert(notebook)
        
        do {
            try modelContext.save()
            notebookName = ""
            viewModel.isNotebookModalOpen = false
        } catch {
            print("Error creating notebook: \(error)")
        }
    }
}

#Preview {
    NewNotebookModal(viewModel: AppViewModel(), userId: UUID())
        .modelContainer(for: Notebook.self, inMemory: true)
}
