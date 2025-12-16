import Foundation
import SwiftUI
import Combine

class OutfitViewModel: ObservableObject {
    @Published var outfits: [OutfitModel] = []
    @Published var selectedSeason: Season? = nil
    @Published var showOnboarding = true
    @Published var isLoading = true
    
    private let userDefaults = UserDefaults.standard
    private let outfitsKey = "SavedOutfits"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadOutfits()
        checkOnboardingStatus()
    }
    
    func addOutfit(_ outfit: OutfitModel) {
        outfits.append(outfit)
        saveOutfits()
    }
    
    func updateOutfit(_ outfit: OutfitModel) {
        if let index = outfits.firstIndex(where: { $0.id == outfit.id }) {
            outfits[index] = outfit
            saveOutfits()
        }
    }
    
    func deleteOutfit(_ outfit: OutfitModel) {
        outfits.removeAll { $0.id == outfit.id }
        saveOutfits()
    }
    
    var filteredOutfits: [OutfitModel] {
        let sorted = outfits.sorted { $0.date > $1.date }
        
        if let season = selectedSeason {
            return sorted.filter { $0.season == season }
        }
        return sorted
    }
    
    func outfitsForSeason(_ season: Season) -> [OutfitModel] {
        return outfits.filter { $0.season == season }.sorted { $0.date > $1.date }
    }
    
    var outfitsWithNotes: [OutfitModel] {
        return outfits.filter { !$0.comment.isEmpty }.sorted { $0.date > $1.date }
    }
    
    func getOutfit(by id: UUID) -> OutfitModel? {
        return outfits.first { $0.id == id }
    }
    
    private func saveOutfits() {
        if let encoded = try? JSONEncoder().encode(outfits) {
            userDefaults.set(encoded, forKey: outfitsKey)
        }
    }
    
    private func loadOutfits() {
        if let data = userDefaults.data(forKey: outfitsKey),
           let decoded = try? JSONDecoder().decode([OutfitModel].self, from: data) {
            outfits = decoded
        }
    }
    
    private func checkOnboardingStatus() {
        showOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
    
    func completeOnboarding() {
        showOnboarding = false
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    func finishLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isLoading = false
        }
    }
    
    func addSampleData() {
        let sampleOutfits = [
            OutfitModel(
                date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
                description: "Denim jacket, white t-shirt, sneakers",
                location: "Park walk",
                weather: "+16°C, sunny",
                comment: "Comfortable, but sneakers were a bit tight."
            ),
            OutfitModel(
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                description: "Summer dress, sandals",
                location: "Beach",
                weather: "+28°C, clear",
                comment: "Perfect for the hot weather!"
            ),
            OutfitModel(
                date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                description: "Coat, boots, scarf",
                location: "Work",
                weather: "+5°C, cloudy",
                comment: "Good for office, a bit cold outside."
            )
        ]
        
        for outfit in sampleOutfits {
            addOutfit(outfit)
        }
    }
}
