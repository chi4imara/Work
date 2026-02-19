import Foundation
import SwiftUI

struct WordEntry: Identifiable, Codable {
    let id: UUID
    var word: String
    var meaning: String
    var association: String
    var dateCreated: Date
    var dateModified: Date
    
    init(word: String, meaning: String = "", association: String = "") {
        self.id = UUID()
        self.word = word
        self.meaning = meaning
        self.association = association
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    mutating func update(word: String? = nil, meaning: String? = nil, association: String? = nil) {
        if let word = word { self.word = word }
        if let meaning = meaning { self.meaning = meaning }
        if let association = association { self.association = association }
        self.dateModified = Date()
    }
}

struct AppSettings: Codable {
    var openWithDictionaryScreen: Bool = true
    var hasCompletedOnboarding: Bool = false
    
    init() {}
}

enum TabItem: String, CaseIterable {
    case dictionary = "Dictionary"
    case all = "All"
    case calendar = "Calendar"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var title: String {
        switch self {
        case .dictionary:
            return "Dictionary"
        case .all:
            return "All"
        case .calendar:
            return "Calendar"
        case .statistics:
            return "Statistics"
        case .settings:
            return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .dictionary:
            return "book.fill"
        case .all:
            return "list.bullet"
        case .calendar:
            return "calendar"
        case .statistics:
            return "chart.bar.fill"
        case .settings:
            return "gear"
        }
    }
}

enum NavigationState {
    case splash
    case onboarding
    case main
}

enum SheetType: Identifiable {
    case addWord
    case editWord(UUID)
    case wordDetail(UUID)
    
    var id: String {
        switch self {
        case .addWord:
            return "addWord"
        case .editWord(let wordId):
            return "editWord_\(wordId)"
        case .wordDetail(let wordId):
            return "wordDetail_\(wordId)"
        }
    }
}
