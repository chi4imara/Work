import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var words: [WordEntry] = []
    @Published var settings: AppSettings = AppSettings()
    
    private let wordsKey = "SavedWords"
    private let settingsKey = "AppSettings"
    
    private init() {
        loadData()
    }
    
    func addWord(_ word: WordEntry) {
        words.append(word)
        saveWords()
    }
    
    func updateWord(_ updatedWord: WordEntry) {
        if let index = words.firstIndex(where: { $0.id == updatedWord.id }) {
            words[index] = updatedWord
            saveWords()
        }
    }
    
    func deleteWord(_ word: WordEntry) {
        words.removeAll { $0.id == word.id }
        saveWords()
    }
    
    func deleteAllWords() {
        words.removeAll()
        saveWords()
    }
    
    func updateSettings(_ newSettings: AppSettings) {
        settings = newSettings
        saveSettings()
    }
    
    func completeOnboarding() {
        settings.hasCompletedOnboarding = true
        saveSettings()
    }
    
    private func loadData() {
        loadWords()
        loadSettings()
    }
    
    private func loadWords() {
        if let data = UserDefaults.standard.data(forKey: wordsKey),
           let decodedWords = try? JSONDecoder().decode([WordEntry].self, from: data) {
            self.words = decodedWords
        }
    }
    
    private func saveWords() {
        if let encodedData = try? JSONEncoder().encode(words) {
            UserDefaults.standard.set(encodedData, forKey: wordsKey)
        }
    }
    
    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let decodedSettings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            self.settings = decodedSettings
        }
    }
    
    private func saveSettings() {
        if let encodedData = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encodedData, forKey: settingsKey)
        }
    }
}
