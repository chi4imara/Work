import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let medicationsKey = "SavedMedications"
    private let dosesKey = "SavedDoses"
    private let referencesKey = "SavedReferences"
    private let onboardingKey = "HasCompletedOnboarding"
    
    private init() {}
    
    func saveMedications(_ medications: [Medication]) {
        if let encoded = try? JSONEncoder().encode(medications) {
            UserDefaults.standard.set(encoded, forKey: medicationsKey)
        }
    }
    
    func loadMedications() -> [Medication] {
        guard let data = UserDefaults.standard.data(forKey: medicationsKey),
              let medications = try? JSONDecoder().decode([Medication].self, from: data) else {
            return []
        }
        return medications
    }
    
    func saveDoses(_ doses: [Dose]) {
        if let encoded = try? JSONEncoder().encode(doses) {
            UserDefaults.standard.set(encoded, forKey: dosesKey)
        }
    }
    
    func loadDoses() -> [Dose] {
        guard let data = UserDefaults.standard.data(forKey: dosesKey),
              let doses = try? JSONDecoder().decode([Dose].self, from: data) else {
            return []
        }
        return doses
    }
    
    func saveReferences(_ references: [MedicineReference]) {
        if let encoded = try? JSONEncoder().encode(references) {
            UserDefaults.standard.set(encoded, forKey: referencesKey)
            print("✅ DataManager: Saved \(references.count) references")
        } else {
            print("❌ DataManager: Failed to encode references")
        }
    }
    
    func loadReferences() -> [MedicineReference] {
        guard let data = UserDefaults.standard.data(forKey: referencesKey),
              let references = try? JSONDecoder().decode([MedicineReference].self, from: data) else {
            print("📭 DataManager: No references found in UserDefaults")
            return []
        }
        print("✅ DataManager: Loaded \(references.count) references")
        return references
    }
    
    func setOnboardingCompleted(_ completed: Bool) {
        UserDefaults.standard.set(completed, forKey: onboardingKey)
    }
    
    func hasCompletedOnboarding() -> Bool {
        return UserDefaults.standard.bool(forKey: onboardingKey)
    }
    
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: medicationsKey)
        UserDefaults.standard.removeObject(forKey: dosesKey)
        UserDefaults.standard.removeObject(forKey: referencesKey)
        UserDefaults.standard.removeObject(forKey: onboardingKey)
    }
}
