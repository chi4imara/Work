import Foundation
import SwiftUI
import StoreKit

struct ThoughtDetailID: Identifiable {
    let id: UUID
}

struct SmileDetailID: Identifiable {
    let id: UUID
}

class MainViewModel: ObservableObject {
    @Published var selectedTab = 0
    @Published var showOnboarding = true
    @Published var showSplash = true
    
    private let dataService = DataService.shared
    
    init() {
        showOnboarding = !UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showSplash = false
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "HasSeenOnboarding")
        showOnboarding = false
    }
}

class HomeViewModel: ObservableObject {
    @Published var todaysSmiles: [Smile] = []
    @Published var showingSmileDetail: SmileDetailID?
    @Published var showingAddSmile = false
    
    private let dataService = DataService.shared
    
    init() {
        loadTodaysSmiles()
        
        dataService.$smiles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadTodaysSmiles()
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func loadTodaysSmiles() {
        todaysSmiles = dataService.getTodaysSmiles()
    }
    
    func deleteSmile(_ smile: Smile) {
        dataService.deleteSmile(smile)
    }
    
    var todaysSmilesCount: Int {
        todaysSmiles.count
    }
}

class AddEditSmileViewModel: ObservableObject {
    @Published var text = ""
    @Published var isEditing = false
    @Published var showingDeleteConfirmation = false
    
    private var originalSmile: Smile?
    private let dataService = DataService.shared
    
    var canSave: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var currentDateTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    func setup(for smile: Smile?) {
        if let smile = smile {
            self.originalSmile = smile
            self.text = smile.text
            self.isEditing = true
        } else {
            self.originalSmile = nil
            self.text = ""
            self.isEditing = false
        }
    }
    
    func save() {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        if let originalSmile = originalSmile {
            var updatedSmile = originalSmile
            updatedSmile.text = trimmedText
            dataService.updateSmile(updatedSmile)
        } else {
            let newSmile = Smile(text: trimmedText)
            dataService.addSmile(newSmile)
        }
    }
    
    func delete() {
        guard let smile = originalSmile else { return }
        dataService.deleteSmile(smile)
    }
}

class AllSmilesViewModel: ObservableObject {
    @Published var groupedSmiles: [(Date, [Smile])] = []
    @Published var showingFilter = false
    @Published var filter = SmileFilter()
    @Published var showingSmileDetail: SmileDetailID?
    
    private let dataService = DataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSmiles()
        
        dataService.$smiles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadSmiles()
            }
            .store(in: &cancellables)
    }
    
    private func loadSmiles() {
        let filteredSmiles = dataService.getFilteredSmiles(filter: filter)
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredSmiles) { smile in
            calendar.startOfDay(for: smile.createdAt)
        }
        
        groupedSmiles = grouped.sorted { $0.key > $1.key }.map { (date, smiles) in
            (date, smiles.sorted { $0.createdAt > $1.createdAt })
        }
    }
    
    func applyFilter() {
        loadSmiles()
        showingFilter = false
    }
    
    func resetFilter() {
        filter = SmileFilter()
        loadSmiles()
        showingFilter = false
    }
    
    func deleteSmile(_ smile: Smile) {
        dataService.deleteSmile(smile)
    }
    
    var isEmpty: Bool {
        groupedSmiles.isEmpty
    }
}

class ThoughtsViewModel: ObservableObject {
    @Published var thoughts: [Thought] = []
    @Published var showingAddThought = false
    @Published var showingThoughtDetail: ThoughtDetailID?
    
    private let dataService = DataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadThoughts()
        
        dataService.$thoughts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] thoughts in
                self?.thoughts = thoughts
            }
            .store(in: &cancellables)
    }
    
    private func loadThoughts() {
        thoughts = dataService.thoughts
    }
    
    func deleteThought(_ thought: Thought) {
        dataService.deleteThought(thought)
    }
    
    var isEmpty: Bool {
        thoughts.isEmpty
    }
}

class AddEditThoughtViewModel: ObservableObject {
    @Published var text = ""
    @Published var isEditing = false
    @Published var showingDeleteConfirmation = false
    
    private var originalThought: Thought?
    private let dataService = DataService.shared
    
    var canSave: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func setup(for thought: Thought?) {
        if let thought = thought {
            self.originalThought = thought
            self.text = thought.text
            self.isEditing = true
        } else {
            self.originalThought = nil
            self.text = ""
            self.isEditing = false
        }
    }
    
    func save() {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        if let originalThought = originalThought {
            var updatedThought = originalThought
            updatedThought.text = trimmedText
            dataService.updateThought(updatedThought)
        } else {
            let newThought = Thought(text: trimmedText)
            dataService.addThought(newThought)
        }
    }
    
    func delete() {
        guard let thought = originalThought else { return }
        dataService.deleteThought(thought)
    }
}

class ProfileViewModel: ObservableObject {
    @Published var statistics = SmileStatistics(totalSmiles: 0, lastSmileDate: nil, maxSmilesInDay: 0, daysWithSmiles: 0)
    @Published var dailyQuote = DailyQuote.todaysQuote()
    @Published var showingAddSmile = false
    
    private let dataService = DataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadStatistics()
        
        dataService.$smiles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadStatistics()
            }
            .store(in: &cancellables)
    }
    
    private func loadStatistics() {
        statistics = dataService.getSmileStatistics()
    }
    
    var hasSmiles: Bool {
        statistics.totalSmiles > 0
    }
}

class SettingsViewModel: ObservableObject {
    func rateApp() {
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

import Combine

