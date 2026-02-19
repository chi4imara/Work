import SwiftUI
import Foundation
import Combine

class WardrobeViewModel: ObservableObject {
    @Published var wardrobeItems: [WardrobeItem] = []
    @Published var categories: [Category] = Category.defaultCategories
    @Published var outfits: [Outfit] = []
    @Published var selectedDate = Date()
    
    private let itemsKey = "WardrobeItems"
    private let categoriesKey = "Categories"
    private let outfitsKey = "Outfits"
    
    init() {
        loadData()
    }
    
    private static var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }
    
    private static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    private func saveData() {
        do {
            let itemsData = try Self.jsonEncoder.encode(wardrobeItems)
            UserDefaults.standard.set(itemsData, forKey: itemsKey)
            let categoriesData = try Self.jsonEncoder.encode(categories)
            UserDefaults.standard.set(categoriesData, forKey: categoriesKey)
            let outfitsData = try Self.jsonEncoder.encode(outfits)
            UserDefaults.standard.set(outfitsData, forKey: outfitsKey)
            UserDefaults.standard.synchronize()
        } catch {
            debugPrint("WardrobeViewModel saveData error: \(error)")
        }
    }
    
    private func loadData() {
        if let itemsData = UserDefaults.standard.data(forKey: itemsKey) {
            do {
                wardrobeItems = try Self.jsonDecoder.decode([WardrobeItem].self, from: itemsData)
            } catch {
                debugPrint("WardrobeViewModel load items error: \(error)")
            }
        }
        
        if let categoriesData = UserDefaults.standard.data(forKey: categoriesKey) {
            do {
                categories = try Self.jsonDecoder.decode([Category].self, from: categoriesData)
            } catch {
                debugPrint("WardrobeViewModel load categories error: \(error)")
                categories = Category.defaultCategories
            }
        }
        
        if let outfitsData = UserDefaults.standard.data(forKey: outfitsKey) {
            do {
                outfits = try Self.jsonDecoder.decode([Outfit].self, from: outfitsData)
            } catch {
                debugPrint("WardrobeViewModel load outfits error: \(error)")
            }
        }
    }
    
    func addItem(_ item: WardrobeItem) {
        wardrobeItems.append(item)
        saveData()
    }
    
    func deleteItem(_ item: WardrobeItem) {
        wardrobeItems.removeAll { $0.id == item.id }
        saveData()
    }
    
    func itemsInCategory(_ categoryName: String) -> [WardrobeItem] {
        return wardrobeItems.filter { $0.category == categoryName }
    }
    
    func item(byId id: UUID) -> WardrobeItem? {
        wardrobeItems.first { $0.id == id }
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        saveData()
    }
    
    func deleteCategory(_ category: Category) {
        categories.removeAll { $0.id == category.id }
        saveData()
    }
    
    func category(byId id: UUID) -> Category? {
        categories.first { $0.id == id }
    }
    
    func addOutfit(_ outfit: Outfit) {
        outfits.append(outfit)
        saveData()
    }
    
    func deleteOutfit(_ outfit: Outfit) {
        outfits.removeAll { $0.id == outfit.id }
        saveData()
    }
    
    func outfitsForDate(_ date: Date) -> [Outfit] {
        let calendar = Calendar.current
        return outfits.filter { calendar.isDate($0.dateCreated, inSameDayAs: date) }
    }
    
    func outfit(byId id: UUID) -> Outfit? {
        outfits.first { $0.id == id }
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
    
    var isEmpty: Bool {
        return wardrobeItems.isEmpty && outfits.isEmpty
    }
    
    func loadSampleData() {
        wardrobeItems = SampleData.sampleItems
        categories = Category.defaultCategories
        outfits = SampleData.makeSampleOutfits(items: wardrobeItems)
        saveData()
    }
}
