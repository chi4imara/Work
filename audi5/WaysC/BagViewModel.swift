import Foundation
import SwiftUI
import Combine

class BagViewModel: ObservableObject {
    @Published var bags: [Bag] = []
    @Published var selectedTab: TabItem = .home
    @Published var showOnboarding = true
    
    private let userDefaults = UserDefaults.standard
    private let bagsKey = "SavedBags"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadBags()
        checkOnboardingStatus()
    }
    
    func addBag(_ bag: Bag) {
        bags.append(bag)
        saveBags()
    }
    
    func updateBag(_ updatedBag: Bag) {
        if let index = bags.firstIndex(where: { $0.id == updatedBag.id }) {
            bags[index] = updatedBag
            saveBags()
        }
    }
    
    func deleteBag(_ bag: Bag) {
        bags.removeAll { $0.id == bag.id }
        saveBags()
    }
    
    func deleteBag(byId id: UUID) {
        bags.removeAll { $0.id == id }
        saveBags()
    }
    
    func getBag(byId id: UUID) -> Bag? {
        return bags.first { $0.id == id }
    }
    
    func bagsByScenario(_ scenario: BagScenario) -> [Bag] {
        return bags.filter { $0.scenario == scenario }
    }
    
    func favoriteBags() -> [Bag] {
        return bags.filter { $0.isFavorite }
    }
    
    func bagCount(for scenario: BagScenario) -> Int {
        return bagsByScenario(scenario).count
    }
    
    private func saveBags() {
        if let encoded = try? JSONEncoder().encode(bags) {
            userDefaults.set(encoded, forKey: bagsKey)
        }
    }
    
    private func loadBags() {
        if let data = userDefaults.data(forKey: bagsKey),
           let decoded = try? JSONDecoder().decode([Bag].self, from: data) {
            bags = decoded
        }
    }
    
    private func checkOnboardingStatus() {
        showOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
    
    func completeOnboarding() {
        showOnboarding = false
        userDefaults.set(true, forKey: onboardingKey)
    }
}
