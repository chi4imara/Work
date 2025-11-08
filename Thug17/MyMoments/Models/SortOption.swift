import Foundation

enum SortOption: String, CaseIterable {
    case newestFirst = "newest_first"
    case oldestFirst = "oldest_first"
    case alphabeticalAZ = "alphabetical_az"
    case alphabeticalZA = "alphabetical_za"
    case byTags = "by_tags"
    
    var displayName: String {
        switch self {
        case .newestFirst:
            return "By Date (Newest First)"
        case .oldestFirst:
            return "By Date (Oldest First)"
        case .alphabeticalAZ:
            return "Alphabetical (A-Z)"
        case .alphabeticalZA:
            return "Alphabetical (Z-A)"
        case .byTags:
            return "By Tags"
        }
    }
    
    func sort(_ stories: [Story]) -> [Story] {
        switch self {
        case .newestFirst:
            return stories.sorted { $0.createdAt > $1.createdAt }
        case .oldestFirst:
            return stories.sorted { $0.createdAt < $1.createdAt }
        case .alphabeticalAZ:
            return stories.sorted { $0.title.lowercased() < $1.title.lowercased() }
        case .alphabeticalZA:
            return stories.sorted { $0.title.lowercased() > $1.title.lowercased() }
        case .byTags:
            return stories.sorted { 
                let firstTagA = $0.tags.first?.lowercased() ?? ""
                let firstTagB = $1.tags.first?.lowercased() ?? ""
                return firstTagA < firstTagB
            }
        }
    }
}
