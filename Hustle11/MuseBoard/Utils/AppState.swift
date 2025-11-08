import SwiftUI

class AppState: ObservableObject {
    @Published var selectedIdeaForEdit: Idea?
    @Published var showingAddEditView = false
    
    func editIdea(_ idea: Idea) {
        selectedIdeaForEdit = idea
        showingAddEditView = true
    }
    
    func addNewIdea() {
        selectedIdeaForEdit = nil
        showingAddEditView = true
    }
    
    func dismissAddEditView() {
        showingAddEditView = false
        selectedIdeaForEdit = nil
    }
}

class NavigationCoordinator: ObservableObject {
    @Published var selectedTab = 0
    @Published var ideaDetailToShow: Idea?
    
    func showIdeaDetail(_ idea: Idea) {
        ideaDetailToShow = idea
    }
    
    func dismissIdeaDetail() {
        ideaDetailToShow = nil
    }
    
    func switchToTab(_ tab: Int) {
        selectedTab = tab
    }
}
