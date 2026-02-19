import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var showSplash = true
    @Published var phases: [Phase] = []
    
    init() {
        loadPhases()
    }
    
    func addPhase(_ phase: Phase) {
        phases.append(phase)
        savePhases()
    }
    
    func updatePhase(_ phase: Phase) {
        if let index = phases.firstIndex(where: { $0.id == phase.id }) {
            phases[index] = phase
            savePhases()
        }
    }
    
    func deletePhase(_ phase: Phase) {
        phases.removeAll { $0.id == phase.id }
        savePhases()
    }
    
    func addWorkoutToPhase(_ workout: Workout, phaseId: UUID) {
        if let index = phases.firstIndex(where: { $0.id == phaseId }) {
            phases[index].workouts.append(workout)
            savePhases()
        }
    }
    
    func deleteWorkoutFromPhase(_ workout: Workout, phaseId: UUID) {
        if let phaseIndex = phases.firstIndex(where: { $0.id == phaseId }) {
            phases[phaseIndex].workouts.removeAll { $0.id == workout.id }
            savePhases()
        }
    }
    
    private func savePhases() {
        if let encoded = try? JSONEncoder().encode(phases) {
            UserDefaults.standard.set(encoded, forKey: Constants.UserDefaultsKeys.phases)
        }
    }
    
    private func loadPhases() {
        if let data = UserDefaults.standard.data(forKey: Constants.UserDefaultsKeys.phases),
           let decoded = try? JSONDecoder().decode([Phase].self, from: data) {
            phases = decoded
        }
    }
    
    func completeSplash() {
        showSplash = false
    }
    
    func completeOnboarding() {
        isFirstLaunch = false
        UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKeys.isFirstLaunch)
    }
}
