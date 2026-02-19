import Foundation
import SwiftUI
import Combine

class DecisionViewModel: ObservableObject {
    @Published var decisions: [Decision] = []
    @Published var searchText: String = ""
    @Published var isFirstLaunch: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let decisionsKey = "SavedDecisions"
    private let firstLaunchKey = "IsFirstLaunch"
    
    init() {
        loadDecisions()
        checkFirstLaunch()
    }
    
    var filteredDecisions: [Decision] {
        if searchText.isEmpty {
            return decisions.sorted { $0.date > $1.date }
        } else {
            return decisions.filter { decision in
                decision.situation.localizedCaseInsensitiveContains(searchText) ||
                decision.chosenOption.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.date > $1.date }
        }
    }
    
    func addDecision(_ decision: Decision) {
        decisions.append(decision)
        saveDecisions()
    }
    
    func updateDecision(_ decision: Decision) {
        if let index = decisions.firstIndex(where: { $0.id == decision.id }) {
            decisions[index] = decision
            saveDecisions()
        }
    }
    
    func deleteDecision(_ decision: Decision) {
        decisions.removeAll { $0.id == decision.id }
        saveDecisions()
    }
    
    func deleteDecision(byId id: UUID) {
        decisions.removeAll { $0.id == id }
        saveDecisions()
    }
    
    func getDecision(byId id: UUID) -> Decision? {
        return decisions.first { $0.id == id }
    }
    
    func completeOnboarding() {
        isFirstLaunch = false
        userDefaults.set(false, forKey: firstLaunchKey)
    }
    
    private func saveDecisions() {
        if let encoded = try? JSONEncoder().encode(decisions) {
            userDefaults.set(encoded, forKey: decisionsKey)
        }
    }
    
    private func loadDecisions() {
        if let data = userDefaults.data(forKey: decisionsKey),
           let decoded = try? JSONDecoder().decode([Decision].self, from: data) {
            decisions = decoded
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
    }
}
