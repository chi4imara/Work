import Foundation
import SwiftUI
import StoreKit
import Combine

class AppViewModel: ObservableObject {
    @Published var navigationState: NavigationState = .splash
    @Published var selectedTab: TabItem = .dictionary
    
    private let dataManager = DataManager.shared
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.dataManager.settings.hasCompletedOnboarding {
                self.navigationState = .main
            } else {
                self.navigationState = .onboarding
            }
        }
    }
    
    func completeOnboarding() {
        dataManager.completeOnboarding()
        navigationState = .main
    }
}

class DictionaryViewModel: ObservableObject {
    @Published var words: [WordEntry] = []
    @Published var presentedSheet: SheetType?
    @Published var showingDeleteAlert = false
    @Published var wordIdToDelete: UUID?
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.words = dataManager.words
        
        dataManager.$words
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newWords in
                guard let self = self else { return }
                if self.words.count != newWords.count ||
                   !self.words.elementsEqual(newWords, by: { $0.id == $1.id }) {
                    self.words = newWords
                }
            }
            .store(in: &cancellables)
    }
    
    func addWord(_ word: WordEntry) {
        dataManager.addWord(word)
        DispatchQueue.main.async {
            self.words = self.dataManager.words
        }
    }
    
    func updateWord(_ word: WordEntry) {
        dataManager.updateWord(word)
        DispatchQueue.main.async {
            self.words = self.dataManager.words
        }
    }
    
    func deleteWord(_ word: WordEntry) {
        dataManager.deleteWord(word)
    }
    
    func deleteWordById(_ wordId: UUID) {
        if let word = words.first(where: { $0.id == wordId }) {
            deleteWord(word)
        }
    }
    
    func getWordById(_ wordId: UUID) -> WordEntry? {
        if let word = words.first(where: { $0.id == wordId }) {
            return word
        }
        return dataManager.words.first(where: { $0.id == wordId })
    }
    
    func showAddWordSheet() {
        presentedSheet = .addWord
    }
    
    func showWordDetail(_ word: WordEntry) {
        if words.first(where: { $0.id == word.id }) == nil {
            words = dataManager.words
        }
        presentedSheet = .wordDetail(word.id)
    }
    
    func showEditWordSheet(_ word: WordEntry) {
        presentedSheet = .editWord(word.id)
    }
    
    func confirmDelete(_ word: WordEntry) {
        wordIdToDelete = word.id
        showingDeleteAlert = true
    }
    
    func executeDelete() {
        if let wordId = wordIdToDelete {
            deleteWordById(wordId)
            wordIdToDelete = nil
        }
        showingDeleteAlert = false
    }
}

class WordFormViewModel: ObservableObject {
    @Published var word: String = ""
    @Published var meaning: String = ""
    @Published var association: String = ""
    
    var isValid: Bool {
        !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(editingWord: WordEntry? = nil) {
        if let editingWord = editingWord {
            self.word = editingWord.word
            self.meaning = editingWord.meaning
            self.association = editingWord.association
        }
    }
    
    func createWordEntry() -> WordEntry {
        return WordEntry(
            word: word.trimmingCharacters(in: .whitespacesAndNewlines),
            meaning: meaning.trimmingCharacters(in: .whitespacesAndNewlines),
            association: association.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    func updateWordEntry(_ existingWord: WordEntry) -> WordEntry {
        var updatedWord = existingWord
        updatedWord.update(
            word: word.trimmingCharacters(in: .whitespacesAndNewlines),
            meaning: meaning.trimmingCharacters(in: .whitespacesAndNewlines),
            association: association.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        return updatedWord
    }
    
    func clear() {
        word = ""
        meaning = ""
        association = ""
    }
}

class SettingsViewModel: ObservableObject {
    @Published var settings: AppSettings
    @Published var showingDeleteAllAlert = false
    
    private let dataManager = DataManager.shared
    
    init() {
        self.settings = dataManager.settings
        
        dataManager.$settings
            .assign(to: &$settings)
    }
    
    func updateSettings() {
        dataManager.updateSettings(settings)
    }
    
    func confirmDeleteAll() {
        showingDeleteAllAlert = true
    }
    
    func deleteAllWords() {
        dataManager.deleteAllWords()
        showingDeleteAllAlert = false
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
