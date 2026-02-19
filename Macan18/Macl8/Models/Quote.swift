import Foundation

struct Quote: Identifiable, Codable, Hashable {
    let id: UUID
    var text: String
    var author: String
    var source: String
    var theme: QuoteTheme
    var comment: String
    var dateCreated: Date
    var dateModified: Date
    
    init(text: String, author: String = "", source: String = "", theme: QuoteTheme = .style, comment: String = "") {
        self.id = UUID()
        self.text = text
        self.author = author
        self.source = source
        self.theme = theme
        self.comment = comment
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    mutating func updateModifiedDate() {
        self.dateModified = Date()
    }
}

enum QuoteTheme: String, CaseIterable, Codable {
    case style = "About Style"
    case dreams = "About Dreams"
    case beauty = "About Beauty"
    case life = "About Life"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .style:
            return "sparkles"
        case .dreams:
            return "star"
        case .beauty:
            return "heart"
        case .life:
            return "leaf"
        }
    }
}

struct QuoteFilter {
    var themes: Set<QuoteTheme> = []
    var author: String = ""
    var keywords: String = ""
    
    var isEmpty: Bool {
        return themes.isEmpty && author.isEmpty && keywords.isEmpty
    }
    
    func matches(_ quote: Quote) -> Bool {
        if !themes.isEmpty && !themes.contains(quote.theme) {
            return false
        }
        
        if !author.isEmpty && !quote.author.localizedCaseInsensitiveContains(author) {
            return false
        }
        
        if !keywords.isEmpty {
            let keywordArray = keywords.components(separatedBy: " ").filter { !$0.isEmpty }
            let searchText = "\(quote.text) \(quote.author) \(quote.source) \(quote.comment)".lowercased()
            
            for keyword in keywordArray {
                if !searchText.contains(keyword.lowercased()) {
                    return false
                }
            }
        }
        
        return true
    }
}
