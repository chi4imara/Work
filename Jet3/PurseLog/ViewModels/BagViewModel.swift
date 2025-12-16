import Foundation
import Combine

enum SortOption: String, CaseIterable {
    case dateAdded = "Date Added"
    case name = "Name"
    case brand = "Brand"
    case usageFrequency = "Usage Frequency"
    case lastUsed = "Last Used"
    
    var displayName: String {
        return self.rawValue
    }
}

class BagViewModel: ObservableObject {
    @Published var bags: [Bag] = []
    @Published var filteredBags: [Bag] = []
    @Published var searchText: String = ""
    @Published var selectedStyle: BagStyle? = nil
    @Published var selectedFrequency: UsageFrequency? = nil
    @Published var selectedColor: String? = nil
    @Published var sortOption: SortOption = .dateAdded
    
    private let userDefaults = UserDefaults.standard
    private let bagsKey = "SavedBags"
    
    init() {
        loadBags()
        setupFiltering()
    }
    
    private func setupFiltering() {
        Publishers.CombineLatest4($bags, $searchText, $selectedStyle, $selectedFrequency)
            .combineLatest($selectedColor)
            .combineLatest($sortOption)
            .map { (bagsSearchStyleFrequencyColor, sort) in
                let (bagsSearchStyleFrequency, selectedColor) = bagsSearchStyleFrequencyColor
                let (bags, searchText, selectedStyle, frequency) = bagsSearchStyleFrequency
                return self.filterAndSortBags(bags: bags, searchText: searchText, style: selectedStyle, frequency: frequency, color: selectedColor, sortOption: sort)
            }
            .assign(to: &$filteredBags)
    }
    
    private func filterAndSortBags(bags: [Bag], searchText: String, style: BagStyle?, frequency: UsageFrequency?, color: String?, sortOption: SortOption) -> [Bag] {
        var filtered = bags
        
        if !searchText.isEmpty {
            filtered = filtered.filter { bag in
                bag.name.localizedCaseInsensitiveContains(searchText) ||
                bag.brand.localizedCaseInsensitiveContains(searchText) ||
                bag.color.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let style = style {
            filtered = filtered.filter { $0.style == style }
        }
        
        if let frequency = frequency {
            filtered = filtered.filter { $0.usageFrequency == frequency }
        }
        
        if let color = color, !color.isEmpty {
            filtered = filtered.filter { $0.color.localizedCaseInsensitiveContains(color) }
        }
        
        return sortBags(filtered, by: sortOption)
    }
    
    func getAllColors() -> [String] {
        let colors = Set(bags.map { $0.color })
        return Array(colors).sorted()
    }
    
    private func sortBags(_ bags: [Bag], by option: SortOption) -> [Bag] {
        switch option {
        case .dateAdded:
            return bags.sorted { $0.dateCreated > $1.dateCreated }
        case .name:
            return bags.sorted { $0.name < $1.name }
        case .brand:
            return bags.sorted { $0.brand < $1.brand }
        case .usageFrequency:
            let frequencyOrder: [UsageFrequency] = [.often, .sometimes, .rarely]
            return bags.sorted { bag1, bag2 in
                let index1 = frequencyOrder.firstIndex(of: bag1.usageFrequency) ?? 999
                let index2 = frequencyOrder.firstIndex(of: bag2.usageFrequency) ?? 999
                if index1 != index2 {
                    return index1 < index2
                }
                return bag1.name < bag2.name
            }
        case .lastUsed:
            return bags.sorted { bag1, bag2 in
                if let date1 = bag1.lastUsedDate, let date2 = bag2.lastUsedDate {
                    return date1 > date2
                } else if bag1.lastUsedDate != nil {
                    return true
                } else if bag2.lastUsedDate != nil {
                    return false
                }
                return bag1.dateCreated > bag2.dateCreated
            }
        }
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
        saveBags()
    }
    
    func clearFilters() {
        searchText = ""
        selectedStyle = nil
        selectedFrequency = nil
        selectedColor = nil
    }
    
    func toggleFavorite(_ bag: Bag) {
        if let index = bags.firstIndex(where: { $0.id == bag.id }) {
            bags[index].isFavorite.toggle()
            saveBags()
        }
    }
    
    func markAsUsed(_ bag: Bag) {
        if let index = bags.firstIndex(where: { $0.id == bag.id }) {
            bags[index].lastUsedDate = Date()
            if bags[index].usageFrequency == .rarely {
                bags[index].usageFrequency = .sometimes
            } else if bags[index].usageFrequency == .sometimes {
                bags[index].usageFrequency = .often
            }
            saveBags()
        }
    }
    
    func updateUsageFrequency(_ bag: Bag, frequency: UsageFrequency) {
        if let index = bags.firstIndex(where: { $0.id == bag.id }) {
            bags[index].usageFrequency = frequency
            if frequency != .rarely {
                bags[index].lastUsedDate = Date()
            }
            saveBags()
        }
    }
    
    func getFavoriteBags() -> [Bag] {
        return bags.filter { $0.isFavorite }.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    func exportToJSON() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let jsonData = try? encoder.encode(bags),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return nil
    }
    
    func getStatistics() -> BagStatistics {
        let styleStats = Dictionary(grouping: bags, by: { $0.style })
            .mapValues { $0.count }
        
        let usageStats = Dictionary(grouping: bags, by: { $0.usageFrequency })
            .mapValues { $0.count }
        
        return BagStatistics(
            styleStats: styleStats,
            usageStats: usageStats,
            totalBags: bags.count
        )
    }
    
    func getBrandStatistics() -> [String: Int] {
        return Dictionary(grouping: bags, by: { $0.brand })
            .mapValues { $0.count }
    }
    
    func getBrandStatisticsSorted() -> [(String, Int)] {
        return Dictionary(grouping: bags, by: { $0.brand })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
    }
    
    func getUnusedBags(daysThreshold: Int = 30) -> [Bag] {
        let thresholdDate = Calendar.current.date(byAdding: .day, value: -daysThreshold, to: Date()) ?? Date()
        return bags.filter { bag in
            if let lastUsed = bag.lastUsedDate {
                return lastUsed < thresholdDate
            }
            return true
        }.sorted { bag1, bag2 in
            let date1 = bag1.lastUsedDate ?? bag1.dateCreated
            let date2 = bag2.lastUsedDate ?? bag2.dateCreated
            return date1 < date2
        }
    }
    
    func saveBags() {
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
}

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    
    private let userDefaults = UserDefaults.standard
    private let notesKey = "SavedNotes"
    
    init() {
        loadNotes()
    }
    
    func addNote(_ note: Note) {
        notes.append(note)
        saveNotes()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            saveNotes()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            userDefaults.set(encoded, forKey: notesKey)
        }
    }
    
    private func loadNotes() {
        if let data = userDefaults.data(forKey: notesKey),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded.sorted { $0.dateCreated > $1.dateCreated }
        }
    }
}
