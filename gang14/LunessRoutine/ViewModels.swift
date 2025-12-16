import Foundation
import SwiftUI
import StoreKit
import Combine

class MainViewModel: ObservableObject {
    @Published var currentPhrase: DailyPhrase?
    @Published var dailyState: DailyState
    @Published var archivedPhrases: [DailyPhrase] = []
    @Published var allPhrases: [DailyPhrase] = []
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    private let userDefaults = UserDefaults.standard
    private let dateFormatter: DateFormatter
    
    init() {
        self.dailyState = DailyState()
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.locale = Locale(identifier: "en_US")
        self.dateFormatter.dateFormat = "dd MMMM yyyy"
        
        loadData()
        checkForNewDay()
    }
    
    private func loadData() {
        loadPhrases()
        loadDailyState()
        loadArchivedPhrases()
        
        if currentPhrase == nil && !allPhrases.isEmpty {
            selectRandomPhrase()
        }
    }
    
    private func loadPhrases() {
        if let data = userDefaults.data(forKey: "allPhrases"),
           let phrases = try? JSONDecoder().decode([DailyPhrase].self, from: data) {
            allPhrases = phrases
        } else {
            allPhrases = DailyPhrase.defaultPhrases
            savePhrases()
        }
    }
    
    private func loadDailyState() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let data = userDefaults.data(forKey: "dailyState"),
           let state = try? JSONDecoder().decode(DailyState.self, from: data),
           Calendar.current.isDate(state.date, inSameDayAs: today) {
            dailyState = state
        } else {
            dailyState = DailyState(date: today)
            saveDailyState()
        }
    }
    
    private func loadArchivedPhrases() {
        if let data = userDefaults.data(forKey: "archivedPhrases"),
           let phrases = try? JSONDecoder().decode([DailyPhrase].self, from: data) {
            archivedPhrases = phrases.sorted { $0.dateAdded > $1.dateAdded }
        }
    }
    
    private func savePhrases() {
        if let data = try? JSONEncoder().encode(allPhrases) {
            userDefaults.set(data, forKey: "allPhrases")
        }
    }
    
    private func saveDailyState() {
        if let data = try? JSONEncoder().encode(dailyState) {
            userDefaults.set(data, forKey: "dailyState")
        }
    }
    
    private func saveArchivedPhrases() {
        if let data = try? JSONEncoder().encode(archivedPhrases) {
            userDefaults.set(data, forKey: "archivedPhrases")
        }
    }
    
    func selectRandomPhrase() {
        guard !allPhrases.isEmpty else { return }
        
        if allPhrases.count == 1 {
            currentPhrase = allPhrases.first
            return
        }
        
        var availablePhrases = allPhrases
        if let current = currentPhrase,
           let index = availablePhrases.firstIndex(where: { $0.text == current.text }) {
            availablePhrases.remove(at: index)
        }
        
        currentPhrase = availablePhrases.randomElement()
    }
    
    func addCurrentPhraseToArchive() {
        guard let phrase = currentPhrase else { return }
        
        if archivedPhrases.contains(where: { $0.text == phrase.text }) {
            showAlert("Already in archive")
            return
        }
        
        if archivedPhrases.count >= 500 {
            showAlert("Archive limit reached")
            return
        }
        
        let archivedPhrase = DailyPhrase(text: phrase.text, dateAdded: Date())
        archivedPhrases.insert(archivedPhrase, at: 0)
        saveArchivedPhrases()
        showAlert("Added to archive")
    }
    
    func toggleLight() {
        dailyState.lightOff.toggle()
        saveDailyState()
    }
    
    func completePractice() {
        dailyState.completed = true
        dailyState.completionsCount += 1
        dailyState.completedAt = Date()
        saveDailyState()
    }
    
    func restoreDefaultPhrases() {
        allPhrases = DailyPhrase.defaultPhrases
        savePhrases()
        selectRandomPhrase()
    }
    
    func clearArchive() {
        archivedPhrases.removeAll()
        saveArchivedPhrases()
    }
    
    func removeFromArchive(_ phrase: DailyPhrase) {
        archivedPhrases.removeAll { $0.id == phrase.id }
        saveArchivedPhrases()
    }
    
    private func checkForNewDay() {
        let today = Calendar.current.startOfDay(for: Date())
        if !Calendar.current.isDate(dailyState.date, inSameDayAs: today) {
            dailyState = DailyState(date: today)
            saveDailyState()
        }
    }
    
    private func showAlert(_ message: String) {
        alertMessage = message
        showingAlert = true
    }
    
    func formattedDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    var todayStatusText: String {
        let dateString = formattedDate(dailyState.date)
        let statusString = dailyState.completed ? "Practice completed" : "Practice not completed"
        return "Today: \(dateString). \(statusString)."
    }
    
    var lightStatusText: String {
        if dailyState.lightOff {
            return "Light is off. The day can be released."
        } else {
            return "Time to turn off the light and let go of the day."
        }
    }
    
    func getTotalPracticeDays() -> Int {
        return dailyState.completed ? 1 : 0
    }
    
    func getCurrentStreak() -> Int {
        return dailyState.completed ? 1 : 0
    }
    
    func getLastPracticeDate() -> String {
        if let completedAt = dailyState.completedAt {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "MMM dd"
            return formatter.string(from: completedAt)
        } else if dailyState.completed {
            return "Today"
        } else {
            return "Not completed"
        }
    }
    
    func getDaysSinceInstall() -> Int {
        return 1
    }
    
    func getLightRemindersCount() -> Int {
        return dailyState.lightOff ? 1 : 0
    }
    
    func addCustomPhrase(_ text: String) {
        let newPhrase = DailyPhrase(text: text, dateAdded: Date())
        allPhrases.append(newPhrase)
        savePhrases()
        
        if currentPhrase == nil {
            currentPhrase = newPhrase
        }
    }
    
    func removePhrase(_ phrase: DailyPhrase) {
        allPhrases.removeAll { $0.id == phrase.id }
        savePhrases()
        
        if currentPhrase?.id == phrase.id {
            selectRandomPhrase()
        }
    }
}

class PracticeViewModel: ObservableObject {
    @Published var currentStep: Int = 1
    @Published var canProceed: Bool = false
    @Published var isRepeatSession: Bool = false
    
    let steps = PracticeStep.allSteps
    private var timer: Timer?
    
    init(isRepeat: Bool = false) {
        self.isRepeatSession = isRepeat
        startStepTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func nextStep() {
        if currentStep < steps.count {
            currentStep += 1
            canProceed = false
            startStepTimer()
        }
    }
    
    func restartPractice() {
        currentStep = 1
        canProceed = false
        startStepTimer()
    }
    
    private func startStepTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            DispatchQueue.main.async {
                self.canProceed = true
            }
        }
    }
    
    var currentStepData: PracticeStep {
        return steps[currentStep - 1]
    }
    
    var isLastStep: Bool {
        return currentStep == steps.count
    }
    
    var progressDots: [Bool] {
        return (1...steps.count).map { $0 <= currentStep }
    }
}

class ArchiveViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var showingDeleteAlert = false
    @Published var phraseToDelete: DailyPhrase?
    
    func filteredPhrases(_ phrases: [DailyPhrase]) -> [DailyPhrase] {
        if searchText.isEmpty {
            return phrases
        }
        return phrases.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
    }
}

class SettingsViewModel: ObservableObject {
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
