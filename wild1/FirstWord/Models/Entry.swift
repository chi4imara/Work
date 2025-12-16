import Foundation
import SwiftUI

struct Entry: Identifiable, Codable {
    let id: UUID
    var phrase: String
    var note: String?
    var date: Date
    var category: Category
    
    init(phrase: String, note: String? = nil, date: Date = Date(), category: Category = .other, id: UUID = UUID()) {
        self.id = id
        self.phrase = phrase
        self.note = note
        self.date = date
        self.category = category
    }
}

enum Category: Codable, Hashable {
    case joke
    case work
    case personal
    case other
    case custom(String)
    
    static var defaultCases: [Category] {
        return [.joke, .work, .personal, .other]
    }
    
    var displayName: String {
        switch self {
        case .joke:
            return "Joke"
        case .work:
            return "Work"
        case .personal:
            return "Personal"
        case .other:
            return "Other"
        case .custom(let name):
            return name
        }
    }
    
    var color: Color {
        switch self {
        case .joke:
            return AppColors.categoryJoke
        case .work:
            return AppColors.categoryWork
        case .personal:
            return AppColors.categoryPersonal
        case .other:
            return AppColors.categoryOther
        case .custom(_):
            return AppColors.primaryPurple
        }
    }
    
    var isCustom: Bool {
        if case .custom(_) = self {
            return true
        }
        return false
    }
}
