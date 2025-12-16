import Foundation

struct IdeaIDWrapper: Identifiable {
    let id: UUID
    let idea: HobbyIdea
    
    init(idea: HobbyIdea) {
        self.id = idea.id
        self.idea = idea
    }
}
