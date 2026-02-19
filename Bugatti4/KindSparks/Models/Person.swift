import Foundation

struct Person: Identifiable, Codable {
    let id = UUID()
    var name: String
    var ideas: [GiftIdea] = []
    
    var ideaCount: Int {
        return ideas.count
    }
}