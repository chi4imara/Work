import Foundation
import SwiftUI
import Combine

enum SearchScope: String, CaseIterable {
    case all = "All"
    case words = "Words"
    case translations = "Translations"
    case comments = "Comments"
}

class WordStore: ObservableObject {
    @Published var words: [Word] = []
    
    private let fileStorage = FileStorageManager.shared
    
    init() {
        loadWords()
    }
    
    func addWord(_ word: Word) {
        if let existingIndex = words.firstIndex(where: { Calendar.current.isDate($0.dateAdded, inSameDayAs: word.dateAdded) }) {
            print("🔄 Updating existing word for date: \(word.dateAdded)")
            words[existingIndex] = word
        } else {
            print("➕ Adding new word: \(word.word)")
            words.append(word)
        }
        print("📊 WordStore now has \(words.count) words")
        saveWords()
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func updateWord(_ word: Word) {
        if let index = words.firstIndex(where: { $0.id == word.id }) {
            words[index] = word
            saveWords()
            
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    func updateWordByDate(_ word: Word, date: Date) {
        if let index = words.firstIndex(where: { Calendar.current.isDate($0.dateAdded, inSameDayAs: date) }) {
            words[index] = word
            saveWords()
        }
    }
    
    func deleteWord(_ word: Word) {
        print("🗑️ Deleting word: \(word.word)")
        words.removeAll { $0.id == word.id }
        saveWords()
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func clearAllWords() {
        words.removeAll()
        saveWords()
    }
    
    var todaysWord: Word? {
        words.first { Calendar.current.isDateInToday($0.dateAdded) }
    }
    
    var sortedWords: [Word] {
        words.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var totalWordsCount: Int {
        words.count
    }
    
    func wordForDate(_ date: Date) -> Word? {
        words.first { Calendar.current.isDate($0.dateAdded, inSameDayAs: date) }
    }
    
    func searchWords(query: String, scope: SearchScope = .all) -> [Word] {
        if query.isEmpty {
            return sortedWords
        }
        
        let searchLowercased = query.lowercased()
        
        return words.filter { word in
            switch scope {
            case .all:
                return word.word.lowercased().contains(searchLowercased) ||
                       (word.translation?.lowercased().contains(searchLowercased) ?? false) ||
                       (word.comment?.lowercased().contains(searchLowercased) ?? false)
            case .words:
                return word.word.lowercased().contains(searchLowercased)
            case .translations:
                return word.translation?.lowercased().contains(searchLowercased) ?? false
            case .comments:
                return word.comment?.lowercased().contains(searchLowercased) ?? false
            }
        }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    func wordsForMonth(_ date: Date) -> [Word] {
        let calendar = Calendar.current
        return words.filter { word in
            calendar.isDate(word.dateAdded, equalTo: date, toGranularity: .month)
        }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    func wordsForYear(_ date: Date) -> [Word] {
        let calendar = Calendar.current
        return words.filter { word in
            calendar.isDate(word.dateAdded, equalTo: date, toGranularity: .year)
        }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var wordsByMonth: [String: [Word]] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        var grouped: [String: [Word]] = [:]
        
        for word in words {
            let monthKey = formatter.string(from: word.dateAdded)
            grouped[monthKey, default: []].append(word)
        }
        
        for key in grouped.keys {
            grouped[key]?.sort { $0.dateAdded > $1.dateAdded }
        }
        
        return grouped
    }
    
    private func saveWords() {
        print("💾 Saving \(words.count) words to file storage")
        if fileStorage.saveWords(words) {
            print("✅ Words saved successfully")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                print("🔄 Forcing UI update after save")
            }
        } else {
            print("❌ Failed to save words to file")
        }
    }
    
    private func loadWords() {
        words = fileStorage.loadWords()
        print("📚 Loaded \(words.count) words from file storage")
    }
}
