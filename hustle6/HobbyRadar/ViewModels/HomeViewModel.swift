import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var currentIdea: Idea?
    @Published var recentHistory: [Idea] = []
    @Published var isGenerating = false
    
    let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        loadInitialData()
    }
    
    private func setupBindings() {
        dataManager.$ideas
            .combineLatest(dataManager.$history)
            .sink { [weak self] _, _ in
                self?.updateRecentHistory()
                self?.updateCurrentIdeaIfNeeded()
            }
            .store(in: &cancellables)
    }
    
    func loadInitialData() {
        if let lastHistoryEntry = dataManager.history.first,
           let lastIdea = dataManager.getIdea(withId: lastHistoryEntry.ideaId) {
            currentIdea = lastIdea
        } else {
            generateNewIdea()
        }
        
        updateRecentHistory()
    }
    
    private func updateRecentHistory() {
        recentHistory = dataManager.getRecentHistory(limit: 10)
    }
    
    private func updateCurrentIdeaIfNeeded() {
        if let currentId = currentIdea?.id,
           let updatedIdea = dataManager.getIdea(withId: currentId) {
            currentIdea = updatedIdea
        }
    }
    
    func generateNewIdea() {
        guard !isGenerating else { return }
        
        isGenerating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            if let newIdea = self.dataManager.generateRandomIdea(excluding: self.currentIdea?.id) {
                self.currentIdea = newIdea
            }
            
            self.isGenerating = false
        }
    }
    
    func toggleCurrentIdeaFavorite() {
        guard let idea = currentIdea else { return }
        dataManager.toggleFavorite(ideaId: idea.id)
    }
    
    func isCurrentIdeaFavorite() -> Bool {
        guard let idea = currentIdea else { return false }
        return dataManager.isFavorite(ideaId: idea.id)
    }
    
    func removeCurrentIdeaFromHistory() {
        guard let idea = currentIdea else { return }
        dataManager.removeFromHistory(ideaId: idea.id)
    }
    
    func isCurrentIdeaInHistory() -> Bool {
        guard let idea = currentIdea else { return false }
        return dataManager.history.contains { $0.ideaId == idea.id }
    }
    
    func selectIdeaFromHistory(_ idea: Idea) {
        currentIdea = idea
    }
    
    func removeIdeaFromHistory(_ idea: Idea) {
        dataManager.removeFromHistory(ideaId: idea.id)
    }
    
    func hasIdeas() -> Bool {
        return !dataManager.ideas.isEmpty
    }
}
