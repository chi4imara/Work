import Foundation

struct Question: Identifiable, Codable, Hashable {
    let id: UUID
    let text: String
    let category: QuestionCategory
    
    init(text: String, category: QuestionCategory) {
        self.id = UUID()
        self.text = text
        self.category = category
    }
}

enum QuestionCategory: String, CaseIterable, Codable {
    case introduction = "Introduction"
    case company = "For Company"
    case personal = "Personal"
    case funny = "Funny"
    case philosophical = "Philosophical"
    case forKids = "For Kids"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .introduction:
            return "person.2"
        case .company:
            return "person.3"
        case .personal:
            return "person"
        case .funny:
            return "face.smiling"
        case .philosophical:
            return "brain.head.profile"
        case .forKids:
            return "figure.child"
        }
    }
}

struct QuestionCollection: Identifiable, Codable {
    let id: UUID
    let title: String
    let icon: String
    let questions: [Question]
    
    init(title: String, icon: String, questions: [Question]) {
        self.id = UUID()
        self.title = title
        self.icon = icon
        self.questions = questions
    }
}

struct FavoriteQuestion: Identifiable, Codable {
    let id: UUID
    let question: Question
    let dateAdded: Date
    
    init(question: Question) {
        self.id = UUID()
        self.question = question
        self.dateAdded = Date()
    }
}

struct HistoryEntry: Identifiable, Codable {
    let id: UUID
    let question: Question
    let dateShown: Date
    
    init(question: Question) {
        self.id = UUID()
        self.question = question
        self.dateShown = Date()
    }
}
