//
//  SearchOverlay.swift
//  Thoughts
//
//  Search overlay for finding notes
//

import SwiftUI

struct SearchOverlay: View {
    @Bindable var viewModel: AppViewModel
    var notes: [Note]
    
    @State private var query: String = ""
    @FocusState private var isSearchFocused: Bool
    
    private var filteredNotes: [Note] {
        guard !query.isEmpty else { return [] }
        let lowercasedQuery = query.lowercased()
        return notes.filter { $0.content.lowercased().contains(lowercasedQuery) }
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.paper.opacity(0.95)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
                .onTapGesture {
                    viewModel.isSearchOpen = false
                }
            
            VStack(spacing: 0) {
                // Search Header
                HStack(spacing: 16) {
                    // Search Field
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.body.weight(.medium))
                            .foregroundColor(.ink.opacity(0.4))
                        
                        TextField("Search thoughts...", text: $query)
                            .font(.body.weight(.medium))
                            .foregroundColor(.ink)
                            .focused($isSearchFocused)
                        
                        if !query.isEmpty {
                            Button(action: { query = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.body)
                                    .foregroundColor(.ink.opacity(0.3))
                            }
                            .accessibilityLabel("Clear search")
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                    )
                    
                    Button("Cancel") {
                        viewModel.isSearchOpen = false
                    }
                    .font(.body.weight(.semibold))
                    .foregroundColor(.ink)
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 16)
                
                // Results
                ScrollView {
                    VStack(spacing: 16) {
                        if query.isEmpty {
                            emptySearchState
                        } else if filteredNotes.isEmpty {
                            noResultsState
                        } else {
                            resultsView
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }
            }
        }
        .onAppear {
            isSearchFocused = true
        }
        .onDisappear {
            query = ""
        }
    }
    
    private var emptySearchState: some View {
        VStack {
            Spacer().frame(height: 80)
            Text("Type to search...")
                .font(.subheadline.weight(.medium))
                .foregroundColor(.ink.opacity(0.3))
        }
    }
    
    private var noResultsState: some View {
        VStack {
            Spacer().frame(height: 80)
            Text("No results found.")
                .font(.subheadline.weight(.medium))
                .foregroundColor(.ink.opacity(0.3))
        }
    }
    
    private var resultsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RESULTS")
                .font(.caption.weight(.bold))
                .foregroundColor(.ink.opacity(0.3))
                .tracking(2)
            
            ForEach(filteredNotes) { note in
                NoteCard(note: note) {
                    viewModel.openNote(id: note.id)
                    viewModel.isSearchOpen = false
                }
            }
        }
    }
}

#Preview {
    SearchOverlay(viewModel: AppViewModel(), notes: [])
}
