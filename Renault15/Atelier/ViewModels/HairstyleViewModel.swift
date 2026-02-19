import Foundation
import SwiftUI
import Combine

class HairstyleViewModel: ObservableObject {
    @Published var hairstyles: [Hairstyle] = []
    @Published var customCategories: [CustomCategory] = []
    @Published var looks: [Look] = []
    
    init() {
        loadData()
    }
    
    func addHairstyle(_ hairstyle: Hairstyle) {
        hairstyles.append(hairstyle)
        saveData()
    }
    
    func addCustomCategory(_ category: CustomCategory) {
        customCategories.append(category)
        saveData()
    }
    
    func addLook(_ look: Look) {
        looks.append(look)
        saveData()
    }
    
    func getHairstyles(for category: HairstyleCategory) -> [Hairstyle] {
        return hairstyles.filter { $0.category == category }
    }
    
    func hairstyle(byId id: UUID) -> Hairstyle? {
        hairstyles.first { $0.id == id }
    }
    
    func look(byId id: UUID) -> Look? {
        looks.first { $0.id == id }
    }
    
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        case 17..<22:
            return "Good Evening"
        default:
            return "Good Evening"
        }
    }
    
    func loadFromStorage() {
        let loaded = DataManager.shared.loadAll()
        hairstyles = loaded.hairstyles
        looks = loaded.looks
        customCategories = loaded.categories
    }
    
    func loadSampleData() {
        hairstyles = SampleData.sampleHairstyles
        looks = SampleData.sampleLooks
        customCategories = SampleData.sampleCategories
        saveData()
    }
    
    func persistToStorage() {
        saveData()
    }
    
    private func loadData() {
        loadFromStorage()
    }
    
    private func saveData() {
        let hairstylesToSave = hairstyles.map { item in
            var copy = item
            copy.photo = ImageCompressor.compress(item.photo)
            return copy
        }
        let looksToSave = looks.map { item in
            var copy = item
            copy.photo = ImageCompressor.compress(item.photo)
            return copy
        }
        DataManager.shared.saveAll(
            hairstyles: hairstylesToSave,
            looks: looksToSave,
            categories: customCategories
        )
    }
}
