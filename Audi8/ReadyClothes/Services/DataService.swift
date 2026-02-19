import Foundation
import Combine

class DataService: ObservableObject {
    static let shared = DataService()
    
    @Published var outfits: [Outfit] = []
    
    private let userDefaults = UserDefaults.standard
    private let outfitsKey = "SavedOutfits"
    
    private init() {
        loadOutfits()
    }
    
    func addOutfit(_ outfit: Outfit) {
        outfits.append(outfit)
        saveOutfits()
    }
    
    func updateOutfit(_ outfit: Outfit) {
        if let index = outfits.firstIndex(where: { $0.id == outfit.id }) {
            outfits[index] = outfit
            saveOutfits()
        }
    }
    
    func deleteOutfit(_ outfit: Outfit) {
        outfits.removeAll { $0.id == outfit.id }
        saveOutfits()
    }
    
    func getOutfitsByCategory(_ category: OutfitCategory) -> [Outfit] {
        return outfits.filter { $0.category == category }
    }
    
    func getFavoriteOutfits() -> [Outfit] {
        return outfits.filter { $0.isFavorite }
    }
    
    private func saveOutfits() {
        do {
            let data = try JSONEncoder().encode(outfits)
            userDefaults.set(data, forKey: outfitsKey)
        } catch {
            print("Failed to save outfits: \(error)")
        }
    }
    
    private func loadOutfits() {
        guard let data = userDefaults.data(forKey: outfitsKey) else { return }
        
        do {
            outfits = try JSONDecoder().decode([Outfit].self, from: data)
        } catch {
            print("Failed to load outfits: \(error)")
        }
    }
}