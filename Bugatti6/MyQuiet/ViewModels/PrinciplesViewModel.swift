import Foundation
import SwiftUI
import Combine

class PrinciplesViewModel: ObservableObject {
    @Published var principles: [Principle] = []
    @Published var isFirstLaunch: Bool = true
    @Published var hasCompletedOnboarding: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let principlesKey = "SavedPrinciples"
    private let onboardingKey = "HasCompletedOnboarding"
    
    init() {
        loadPrinciples()
        checkOnboardingStatus()
    }
    
    func checkOnboardingStatus() {
        hasCompletedOnboarding = userDefaults.bool(forKey: onboardingKey)
        isFirstLaunch = !hasCompletedOnboarding
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        isFirstLaunch = false
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    func addPrinciple(_ text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let newPrinciple = Principle(text: trimmedText)
        principles.append(newPrinciple)
        savePrinciples()
    }
    
    func updatePrinciple(_ principle: Principle, with newText: String) {
        guard let index = principles.firstIndex(where: { $0.id == principle.id }) else { return }
        
        let trimmedText = newText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        principles[index].updateText(trimmedText)
        savePrinciples()
    }
    
    func deletePrinciple(_ principle: Principle) {
        principles.removeAll { $0.id == principle.id }
        savePrinciples()
    }
    
    func getPrinciple(by id: UUID) -> Principle? {
        return principles.first { $0.id == id }
    }
    
    var isEmpty: Bool {
        return principles.isEmpty
    }
    
    func loadSampleData() {
        for text in SampleData.principleTexts {
            let principle = Principle(text: text)
            principles.append(principle)
        }
        savePrinciples()
    }
    
    private func savePrinciples() {
        do {
            let data = try JSONEncoder().encode(principles)
            userDefaults.set(data, forKey: principlesKey)
        } catch {
            print("Failed to save principles: \(error)")
        }
    }
    
    private func loadPrinciples() {
        guard let data = userDefaults.data(forKey: principlesKey) else { return }
        
        do {
            principles = try JSONDecoder().decode([Principle].self, from: data)
        } catch {
            print("Failed to load principles: \(error)")
            principles = []
        }
    }
}
