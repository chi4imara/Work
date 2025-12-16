import Foundation
import SwiftUI
import Combine

class MemoryStore: ObservableObject {
    @Published var memories: [Memory] = []
    @Published var hasSeenOnboarding = false
    
    private let userDefaults = UserDefaults.standard
    private let memoriesKey = "SavedMemories"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadMemories()
        loadOnboardingStatus()
    }
        
    func addMemory(_ memory: Memory) {
        memories.append(memory)
        saveMemories()
    }
    
    func updateMemory(_ memory: Memory) {
        if let index = memories.firstIndex(where: { $0.id == memory.id }) {
            memories[index] = memory
            saveMemories()
        }
    }
    
    func deleteMemory(_ memory: Memory) {
        memories.removeAll { $0.id == memory.id }
        saveMemories()
    }
    
    func toggleFavorite(_ memory: Memory) {
        if let index = memories.firstIndex(where: { $0.id == memory.id }) {
            memories[index].isFavorite.toggle()
            saveMemories()
        }
    }
        
    func memoryForDate(_ date: Date) -> Memory? {
        return memories.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func memoryForID(_ id: UUID) -> Memory? {
        return memories.first { $0.id == id }
    }
    
    func memoriesForLastDays(_ days: Int) -> [Memory] {
        let calendar = Calendar.current
        let today = Date()
        
        return memories.filter { memory in
            let daysDifference = calendar.dateComponents([.day], from: memory.date, to: today).day ?? 0
            return daysDifference >= 0 && daysDifference < days
        }.sorted { $0.date > $1.date }
    }
    
    var favoriteMemories: [Memory] {
        return memories.filter { $0.isFavorite }.sorted { $0.date > $1.date }
    }
    
    func memoriesForMonth(_ date: Date) -> [Memory] {
        let calendar = Calendar.current
        return memories.filter { memory in
            calendar.isDate(memory.date, equalTo: date, toGranularity: .month)
        }
    }
    
    func memoriesForYear(_ date: Date) -> [Memory] {
        let calendar = Calendar.current
        return memories.filter { memory in
            calendar.isDate(memory.date, equalTo: date, toGranularity: .year)
        }
    }
        
    func monthlyStats(for date: Date) -> (recordedDays: Int, missedDays: Int, mostFrequentMood: String) {
        let calendar = Calendar.current
        let monthMemories = memoriesForMonth(date)
        
        let daysInMonth = calendar.range(of: .day, in: .month, for: date)?.count ?? 30
        let recordedDays = monthMemories.count
        let missedDays = daysInMonth - recordedDays
        
        let moodCounts = Dictionary(grouping: monthMemories, by: { $0.mood })
            .mapValues { $0.count }
        let mostFrequentMood = moodCounts.max(by: { $0.value < $1.value })?.key ?? "😊"
        
        return (recordedDays, missedDays, mostFrequentMood)
    }
    
    func yearlyStats(for date: Date) -> (totalRecords: Int, bestMonth: String) {
        let calendar = Calendar.current
        let yearMemories = memoriesForYear(date)
        
        let monthCounts = Dictionary(grouping: yearMemories) { memory in
            calendar.dateComponents([.month], from: memory.date).month ?? 1
        }.mapValues { $0.count }
        
        let bestMonthNumber = monthCounts.max(by: { $0.value < $1.value })?.key ?? 1
        let bestMonth = calendar.monthSymbols[bestMonthNumber - 1]
        
        return (yearMemories.count, bestMonth)
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
        }
    }
        
    func completeOnboarding() {
        hasSeenOnboarding = true
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    private func loadOnboardingStatus() {
        hasSeenOnboarding = userDefaults.bool(forKey: onboardingKey)
    }
}
