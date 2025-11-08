import Foundation
import SwiftUI
import Combine

class MemoryStore: ObservableObject {
    @Published var memories: [Memory] = []
    @Published var filteredMemories: [Memory] = []
    @Published var currentFilter: DateFilter = .all
    
    enum DateFilter: String, CaseIterable {
        case all = "All Time"
        case today = "Today"
        case week = "Week"
        case month = "Month"
        
        var localizedTitle: String {
            switch self {
            case .all: return "All Time"
            case .today: return "Today"
            case .week: return "Week"
            case .month: return "Month"
            }
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let memoriesKey = "SavedMemories"
    
    init() {
        loadMemories()
        applyFilter()
    }
    
    func addMemory(_ memory: Memory) {
        memories.append(memory)
        sortMemories()
        saveMemories()
        applyFilter()
    }
    
    func updateMemory(_ memory: Memory) {
        if let index = memories.firstIndex(where: { $0.id == memory.id }) {
            memories[index] = memory
            sortMemories()
            saveMemories()
            applyFilter()
        }
    }
    
    func deleteMemory(_ memory: Memory) {
        memories.removeAll { $0.id == memory.id }
        saveMemories()
        applyFilter()
    }
    
    func clearAllMemories() {
        memories.removeAll()
        saveMemories()
        applyFilter()
    }
    
    func setFilter(_ filter: DateFilter) {
        currentFilter = filter
        applyFilter()
    }
    
    private func sortMemories() {
        memories.sort { $0.createdAt > $1.createdAt }
    }
    
    private func applyFilter() {
        let calendar = Calendar.current
        let now = Date()
        
        switch currentFilter {
        case .all:
            filteredMemories = memories
        case .today:
            filteredMemories = memories.filter { calendar.isDate($0.date, inSameDayAs: now) }
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            filteredMemories = memories.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            filteredMemories = memories.filter { $0.date >= monthAgo }
        }
    }

    private func saveMemories() {
        if let encoded = try? JSONEncoder().encode(memories) {
            userDefaults.set(encoded, forKey: memoriesKey)
        }
    }
    
    private func loadMemories() {
        if let data = userDefaults.data(forKey: memoriesKey),
           let decoded = try? JSONDecoder().decode([Memory].self, from: data) {
            memories = decoded
            sortMemories()
        }
    }
    
    var totalMemories: Int {
        filteredMemories.count
    }
    
    var importantMemories: Int {
        filteredMemories.filter { $0.isImportant }.count
    }
    
    var averageTextLength: Int {
        guard !filteredMemories.isEmpty else { return 0 }
        let totalLength = filteredMemories.reduce(0) { $0 + $1.text.count }
        return totalLength / filteredMemories.count
    }
    
    var busiestDay: (date: Date, count: Int)? {
        let calendar = Calendar.current
        let groupedByDate = Dictionary(grouping: filteredMemories) { memory in
            calendar.startOfDay(for: memory.date)
        }
        
        return groupedByDate.max { $0.value.count < $1.value.count }
            .map { (date: $0.key, count: $0.value.count) }
    }
    
    func memoriesForDate(_ date: Date) -> [Memory] {
        let calendar = Calendar.current
        return memories.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    func hasMemoriesForDate(_ date: Date) -> Bool {
        !memoriesForDate(date).isEmpty
    }
    
    func memoryCountForDate(_ date: Date) -> Int {
        memoriesForDate(date).count
    }
}
