import Foundation
import SwiftUI
import StoreKit
import Combine

class AppViewModel: ObservableObject {
    @Published var appState: AppState = .onboarding
    @Published var selectedTab: TabItem = .home
    @Published var hasCompletedOnboarding: Bool = false
    
    init() {
        loadOnboardingStatus()
        FontManager.shared.registerFonts()
    }
    
    private func loadOnboardingStatus() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        appState = .main
    }
    
    func completeSplash() {
        appState = hasCompletedOnboarding ? .main : .onboarding
    }
}

class DailyMomentsViewModel: ObservableObject {
    @Published var moments: [DailyMoment] = []
    @Published var todaysMoment: DailyMoment?
    @Published var isLoading = false
    @Published var showingEditSheet = false
    @Published var showingCreateSheet = false
    
    private let userDefaults = UserDefaults.standard
    private let momentsKey = "savedMoments"
    
    init() {
        loadMoments()
        checkTodaysMoment()
    }
    
    private func loadMoments() {
        if let data = userDefaults.data(forKey: momentsKey),
           let decodedMoments = try? JSONDecoder().decode([DailyMoment].self, from: data) {
            moments = decodedMoments.sorted { $0.date > $1.date }
        }
    }
    
    private func saveMoments() {
        if let encoded = try? JSONEncoder().encode(moments) {
            userDefaults.set(encoded, forKey: momentsKey)
        }
    }
    
    private func checkTodaysMoment() {
        let today = Calendar.current.startOfDay(for: Date())
        todaysMoment = moments.first { moment in
            Calendar.current.isDate(moment.date, inSameDayAs: today)
        }
    }
    
    func saveMoment(_ text: String) {
        let newMoment = DailyMoment(text: text)
        
        let today = Calendar.current.startOfDay(for: Date())
        moments.removeAll { moment in
            Calendar.current.isDate(moment.date, inSameDayAs: today)
        }
        
        moments.insert(newMoment, at: 0)
        todaysMoment = newMoment
        saveMoments()
    }
    
    func updateMoment(_ moment: DailyMoment, with text: String) {
        if let index = moments.firstIndex(where: { $0.id == moment.id }) {
            moments[index].text = text
            moments[index].updatedAt = Date()
            
            if Calendar.current.isDate(moment.date, inSameDayAs: Date()) {
                todaysMoment = moments[index]
            }
            
            saveMoments()
        }
    }
    
    func deleteMoment(_ moment: DailyMoment) {
        moments.removeAll { $0.id == moment.id }
        
        if todaysMoment?.id == moment.id {
            todaysMoment = nil
        }
        
        saveMoments()
    }
    
    func canEditToday() -> Bool {
        guard let todaysMoment = todaysMoment else { return true }
        
        let calendar = Calendar.current
        let now = Date()
        let momentDate = todaysMoment.createdAt
        
        return calendar.isDate(momentDate, inSameDayAs: now)
    }
    
    func filteredMoments(searchText: String, dateRange: DateInterval?) -> [DailyMoment] {
        var filtered = moments
        
        if !searchText.isEmpty {
            filtered = filtered.filter { moment in
                moment.text.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let dateRange = dateRange {
            filtered = filtered.filter { moment in
                dateRange.contains(moment.date)
            }
        }
        
        return filtered
    }
}

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var isLoading = false
    @Published var showingCreateSheet = false
    @Published var showingEditSheet = false
    @Published var selectedNote: Note?
    
    private let userDefaults = UserDefaults.standard
    private let notesKey = "savedNotes"
    
    init() {
        loadNotes()
    }
    
    private func loadNotes() {
        if let data = userDefaults.data(forKey: notesKey),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decodedNotes.sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            userDefaults.set(encoded, forKey: notesKey)
        }
    }
    
    func addNote(_ text: String) {
        let newNote = Note(text: text)
        notes.insert(newNote, at: 0)
        saveNotes()
    }
    
    func updateNote(_ note: Note, with text: String) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].text = text
            notes[index].updatedAt = Date()
            saveNotes()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
}

class ProfileViewModel: ObservableObject {
    @Published var statistics = UserStatistics()
    @Published var dailyQuote: DailyQuote
    
    private let userDefaults = UserDefaults.standard
    private let lastQuoteDateKey = "lastQuoteDate"
    private let currentQuoteKey = "currentQuote"
    
    init() {
        self.dailyQuote = DailyQuote.randomQuote()
        loadDailyQuote()
    }
    
    func updateStatistics(moments: [DailyMoment]) {
        statistics.totalDaysWithEntries = moments.count
        statistics.lastMomentDate = moments.first?.createdAt
        statistics.currentStreak = calculateCurrentStreak(moments: moments)
        statistics.averageEntryTime = calculateAverageTime(moments: moments)
    }
    
    private func calculateCurrentStreak(moments: [DailyMoment]) -> Int {
        guard !moments.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        var currentDate = today
        
        let momentDates = Set(moments.map { calendar.startOfDay(for: $0.date) })
        
        while momentDates.contains(currentDate) {
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }
        
        return streak
    }
    
    private func calculateAverageTime(moments: [DailyMoment]) -> String {
        guard !moments.isEmpty else { return "00:00" }
        
        let calendar = Calendar.current
        let totalMinutes = moments.reduce(0) { total, moment in
            let components = calendar.dateComponents([.hour, .minute], from: moment.createdAt)
            return total + (components.hour ?? 0) * 60 + (components.minute ?? 0)
        }
        
        let averageMinutes = totalMinutes / moments.count
        let hours = averageMinutes / 60
        let minutes = averageMinutes % 60
        
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    private func loadDailyQuote() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastQuoteDate = userDefaults.object(forKey: lastQuoteDateKey) as? Date,
           Calendar.current.isDate(lastQuoteDate, inSameDayAs: today),
           let quoteData = userDefaults.data(forKey: currentQuoteKey),
           let savedQuote = try? JSONDecoder().decode(DailyQuote.self, from: quoteData) {
            dailyQuote = savedQuote
        } else {
            dailyQuote = DailyQuote.randomQuote()
            saveDailyQuote()
        }
    }
    
    private func saveDailyQuote() {
        userDefaults.set(Date(), forKey: lastQuoteDateKey)
        if let encoded = try? JSONEncoder().encode(dailyQuote) {
            userDefaults.set(encoded, forKey: currentQuoteKey)
        }
    }
}

class SettingsViewModel: ObservableObject {
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

