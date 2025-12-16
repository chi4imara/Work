import Foundation
import Combine

class DataManager: ObservableObject {
    @Published var gifts: [Gift] = []
    @Published var categories: [Category] = []
    @Published var events: [Event] = []
    @Published var giftEventRelations: [GiftEventRelation] = []
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadData()
        if categories.isEmpty {
            categories = Category.defaultCategories
            saveCategories()
        }
    }
    
    private func loadData() {
        loadGifts()
        loadCategories()
        loadEvents()
        loadGiftEventRelations()
    }
    
    private func loadGifts() {
        if let data = userDefaults.data(forKey: "gifts"),
           let decodedGifts = try? JSONDecoder().decode([Gift].self, from: data) {
            gifts = decodedGifts
        }
    }
    
    private func saveGifts() {
        if let encoded = try? JSONEncoder().encode(gifts) {
            userDefaults.set(encoded, forKey: "gifts")
        }
    }
    
    private func loadCategories() {
        if let data = userDefaults.data(forKey: "categories"),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: data) {
            categories = decodedCategories
        }
    }
    
    private func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            userDefaults.set(encoded, forKey: "categories")
        }
    }
    
    private func loadEvents() {
        if let data = userDefaults.data(forKey: "events"),
           let decodedEvents = try? JSONDecoder().decode([Event].self, from: data) {
            events = decodedEvents
        }
    }
    
    private func saveEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            userDefaults.set(encoded, forKey: "events")
        }
    }
    
    private func loadGiftEventRelations() {
        if let data = userDefaults.data(forKey: "giftEventRelations"),
           let decodedRelations = try? JSONDecoder().decode([GiftEventRelation].self, from: data) {
            giftEventRelations = decodedRelations
        }
    }
    
    private func saveGiftEventRelations() {
        if let encoded = try? JSONEncoder().encode(giftEventRelations) {
            userDefaults.set(encoded, forKey: "giftEventRelations")
        }
    }
    
    func addGift(_ gift: Gift) {
        gifts.append(gift)
        saveGifts()
    }
    
    func updateGift(_ gift: Gift) {
        if let index = gifts.firstIndex(where: { $0.id == gift.id }) {
            var updatedGift = gift
            updatedGift.updatedAt = Date()
            gifts[index] = updatedGift
            saveGifts()
        }
    }
    
    func deleteGift(_ gift: Gift) {
        gifts.removeAll { $0.id == gift.id }
        giftEventRelations.removeAll { $0.giftId == gift.id }
        saveGifts()
        saveGiftEventRelations()
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        saveCategories()
    }
    
    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            var updatedCategory = category
            updatedCategory.updatedAt = Date()
            categories[index] = updatedCategory
            saveCategories()
        }
    }
    
    func deleteCategory(_ category: Category) {
        let hasGifts = gifts.contains { $0.categoryId == category.id }
        if !hasGifts {
            categories.removeAll { $0.id == category.id }
            saveCategories()
        }
    }
    
    func canDeleteCategory(_ category: Category) -> Bool {
        return !gifts.contains { $0.categoryId == category.id }
    }
    
    func addEvent(_ event: Event) {
        events.append(event)
        saveEvents()
    }
    
    func updateEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            var updatedEvent = event
            updatedEvent.updatedAt = Date()
            events[index] = updatedEvent
            saveEvents()
        }
    }
    
    func deleteEvent(_ event: Event) {
        events.removeAll { $0.id == event.id }
        giftEventRelations.removeAll { $0.eventId == event.id }
        saveEvents()
        saveGiftEventRelations()
    }
    
    func addGiftToEvent(giftId: UUID, eventId: UUID) {
        let relation = GiftEventRelation(giftId: giftId, eventId: eventId)
        giftEventRelations.append(relation)
        saveGiftEventRelations()
    }
    
    func removeGiftFromEvent(giftId: UUID, eventId: UUID) {
        giftEventRelations.removeAll { $0.giftId == giftId && $0.eventId == eventId }
        saveGiftEventRelations()
    }
    
    func getEventsForGift(_ giftId: UUID) -> [Event] {
        let eventIds = giftEventRelations.filter { $0.giftId == giftId }.map { $0.eventId }
        return events.filter { eventIds.contains($0.id) }
    }
    
    func getGiftsForEvent(_ eventId: UUID) -> [Gift] {
        let giftIds = giftEventRelations.filter { $0.eventId == eventId }.map { $0.giftId }
        return gifts.filter { giftIds.contains($0.id) }
    }
    
    func getCategoryName(for categoryId: UUID) -> String {
        return categories.first { $0.id == categoryId }?.name ?? "Unknown"
    }
    
    func getCategoryIcon(for categoryId: UUID) -> String {
        return categories.first { $0.id == categoryId }?.iconName ?? "questionmark"
    }
    
    func getCategory(for categoryId: UUID) -> Category? {
        return categories.first { $0.id == categoryId }
    }
}
