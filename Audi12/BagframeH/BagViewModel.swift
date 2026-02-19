import Foundation
import Combine

class BagViewModel: ObservableObject {
    @Published var bags: [Bag] = []
    @Published var selectedBag: Bag?
    @Published var favoriteBagIds: Set<UUID> = []
    
    private let userDefaults = UserDefaults.standard
    private let bagsKey = "SavedBags"
    private let favoritesKey = "FavoriteBagIds"
    
    init() {
        loadBags()
        loadFavorites()
    }
    
    func addBag(_ bag: Bag) {
        bags.append(bag)
        saveBags()
    }
    
    func updateBag(_ bag: Bag) {
        if let index = bags.firstIndex(where: { $0.id == bag.id }) {
            bags[index] = bag
            saveBags()
        }
    }
    
    func deleteBag(_ bag: Bag) {
        bags.removeAll { $0.id == bag.id }
        if selectedBag?.id == bag.id {
            selectedBag = nil
        }
        saveBags()
    }
    
    func addItem(_ item: Item, to bag: Bag) {
        if let index = bags.firstIndex(where: { $0.id == bag.id }) {
            bags[index].items.append(item)
            if selectedBag?.id == bag.id {
                selectedBag = bags[index]
            }
            saveBags()
        }
    }
    
    func removeItem(_ item: Item, from bag: Bag) {
        if let bagIndex = bags.firstIndex(where: { $0.id == bag.id }) {
            bags[bagIndex].items.removeAll { $0.id == item.id }
            if selectedBag?.id == bag.id {
                selectedBag = bags[bagIndex]
            }
            saveBags()
        }
    }
    
    func getBagsForScenario(_ scenario: DayScenario) -> [Bag] {
        return bags.filter { bag in
            bag.description.lowercased().contains(scenario.rawValue.lowercased()) ||
            bag.description.lowercased().contains(scenario.rawValue.components(separatedBy: " ").first?.lowercased() ?? "")
        }
    }
    
    func getBag(by id: UUID) -> Bag? {
        return bags.first { $0.id == id }
    }
    
    func toggleFavorite(bagId: UUID) {
        if favoriteBagIds.contains(bagId) {
            favoriteBagIds.remove(bagId)
        } else {
            favoriteBagIds.insert(bagId)
        }
        saveFavorites()
    }
    
    func isFavorite(bagId: UUID) -> Bool {
        return favoriteBagIds.contains(bagId)
    }
    
    func getFavoriteBags() -> [Bag] {
        return bags.filter { favoriteBagIds.contains($0.id) }
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
    
    private func saveFavorites() {
        let idsArray = Array(favoriteBagIds)
        if let encoded = try? JSONEncoder().encode(idsArray) {
            userDefaults.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([UUID].self, from: data) {
            favoriteBagIds = Set(decoded)
        }
    }
}
