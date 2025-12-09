//
//  AppViewModel.swift
//  Thoughts
//
//  Main app state management
//

import Foundation
import SwiftUI
import SwiftData

enum AppStatus {
    case loading
    case onboarding
    case auth
    case app
}

enum ViewState: Equatable {
    case home
    case notebook(notebookId: UUID)
    case editor(noteId: UUID?, notebookId: UUID?, isNew: Bool)
}

@Observable
class AppViewModel {
    var appStatus: AppStatus = .loading
    var currentUser: User?
    var viewState: ViewState = .home
    var onboardingName: String = ""
    
    // Modal states
    var isNotebookModalOpen = false
    var isSettingsOpen = false
    var isSearchOpen = false
    var newNotebookName = ""
    
    private let userDefaultsKey = "thoughts_user_session"
    
    init() {
        checkSavedSession()
    }
    
    private func checkSavedSession() {
        if let savedUserId = UserDefaults.standard.string(forKey: userDefaultsKey) {
            // User ID is saved, we'll fetch the user in ContentView
            appStatus = .app
        } else {
            appStatus = .onboarding
        }
    }
    
    func completeOnboarding(name: String) {
        onboardingName = name
        appStatus = .auth
    }
    
    func skipToLogin() {
        appStatus = .auth
    }
    
    func login(user: User) {
        currentUser = user
        UserDefaults.standard.set(user.id.uuidString, forKey: userDefaultsKey)
        appStatus = .app
        onboardingName = ""
    }
    
    func logout() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        viewState = .home
        isSettingsOpen = false
        appStatus = .onboarding
    }
    
    func navigateHome() {
        viewState = .home
    }
    
    func openNotebook(id: UUID) {
        viewState = .notebook(notebookId: id)
    }
    
    func openNote(id: UUID, notebookId: UUID? = nil) {
        viewState = .editor(noteId: id, notebookId: notebookId, isNew: false)
    }
    
    func createNote() {
        var notebookId: UUID? = nil
        if case .notebook(let nbId) = viewState {
            notebookId = nbId
        }
        viewState = .editor(noteId: nil, notebookId: notebookId, isNew: true)
    }
    
    func closeEditor(notebookId: UUID?) {
        if let notebookId = notebookId {
            viewState = .notebook(notebookId: notebookId)
        } else {
            viewState = .home
        }
    }
    
    func getSavedUserId() -> UUID? {
        if let savedUserId = UserDefaults.standard.string(forKey: userDefaultsKey) {
            return UUID(uuidString: savedUserId)
        }
        return nil
    }
}
