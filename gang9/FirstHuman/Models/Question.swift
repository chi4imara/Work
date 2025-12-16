import Foundation

struct Question: Identifiable, Codable {
    let id = UUID()
    let text: String
    let category: QuestionCategory
    
    enum QuestionCategory: String, CaseIterable, Codable {
        case daily = "daily"
        case random = "random"
    }
}

struct DailyAnswer: Identifiable, Codable {
    let id: UUID
    let questionId: UUID
    let questionText: String
    var answer: String
    let date: Date
    let createdAt: Date
    
    init(id: UUID = UUID(), questionId: UUID, questionText: String, answer: String, date: Date, createdAt: Date) {
        self.id = id
        self.questionId = questionId
        self.questionText = questionText
        self.answer = answer
        self.date = date
        self.createdAt = createdAt
    }
}

struct PersonalNote: Identifiable, Codable {
    let id: UUID
    var content: String
    let createdAt: Date
    var updatedAt: Date
    let isFromRandomQuestion: Bool
    
    init(id: UUID = UUID(), content: String, createdAt: Date, updatedAt: Date, isFromRandomQuestion: Bool) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isFromRandomQuestion = isFromRandomQuestion
    }
    
    var title: String {
        let lines = content.components(separatedBy: .newlines)
        return lines.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Untitled Note"
    }
    
    var preview: String {
        let lines = content.components(separatedBy: .newlines)
        let previewLines = Array(lines.prefix(3))
        return previewLines.joined(separator: "\n")
    }
}

struct UserStats {
    let totalDailyAnswers: Int
    let currentStreak: Int
    let totalPersonalNotes: Int
    let longestAnswerWordCount: Int
}

struct Quote: Identifiable {
    let id = UUID()
    let text: String
    let author: String?
}
