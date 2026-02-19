import Foundation
import SwiftUI
import StoreKit
import Combine

class OutfitViewModel: ObservableObject {
    @Published var outfits: [OutfitEntry] = []
    @Published var tags: [Tag] = []
    @Published var searchText = ""
    @Published var showingCalendarView = false
    
    private let userDefaults = UserDefaults.standard
    private let outfitsKey = "SavedOutfits"
    private let tagsKey = "SavedTags"
    
    init() {
        loadData()
    }
    
    func saveData() {
        if let outfitsData = try? JSONEncoder().encode(outfits) {
            userDefaults.set(outfitsData, forKey: outfitsKey)
        }
        
        if let tagsData = try? JSONEncoder().encode(tags) {
            userDefaults.set(tagsData, forKey: tagsKey)
        }
    }
    
    func loadData() {
        if let outfitsData = userDefaults.data(forKey: outfitsKey),
           let decodedOutfits = try? JSONDecoder().decode([OutfitEntry].self, from: outfitsData) {
            outfits = decodedOutfits
        }
        
        if let tagsData = userDefaults.data(forKey: tagsKey),
           let decodedTags = try? JSONDecoder().decode([Tag].self, from: tagsData) {
            tags = decodedTags
        }
    }
    
    func addOutfit(_ outfit: OutfitEntry) {
        outfits.append(outfit)
        updateTagUsage(for: outfit.tags)
        saveData()
    }
    
    func updateOutfit(_ outfit: OutfitEntry) {
        if let index = outfits.firstIndex(where: { $0.id == outfit.id }) {
            outfits[index] = outfit
            recalculateTagUsage()
            saveData()
        }
    }
    
    func deleteOutfit(_ outfit: OutfitEntry) {
        outfits.removeAll { $0.id == outfit.id }
        recalculateTagUsage()
        saveData()
    }
    
    func addTag(_ tagName: String) {
        let trimmedName = tagName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty,
              !tags.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) else { return }
        
        tags.append(Tag(name: trimmedName))
        saveData()
    }
    
    func updateTag(oldName: String, newName: String) {
        let trimmedNewName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedNewName.isEmpty else { return }
        
        if let index = tags.firstIndex(where: { $0.name == oldName }) {
            tags[index].name = trimmedNewName
        }
        
        for i in 0..<outfits.count {
            for j in 0..<outfits[i].tags.count {
                if outfits[i].tags[j] == oldName {
                    outfits[i].tags[j] = trimmedNewName
                }
            }
        }
        
        saveData()
    }
    
    func deleteTag(_ tagName: String) {
        tags.removeAll { $0.name == tagName }
        
        for i in 0..<outfits.count {
            outfits[i].tags.removeAll { $0 == tagName }
        }
        
        saveData()
    }
    
    private func updateTagUsage(for tagNames: [String]) {
        for tagName in tagNames {
            if let index = tags.firstIndex(where: { $0.name == tagName }) {
                tags[index].usageCount += 1
            } else {
                var newTag = Tag(name: tagName)
                newTag.usageCount = 1
                tags.append(newTag)
            }
        }
    }
    
    private func recalculateTagUsage() {
        for i in 0..<tags.count {
            tags[i].usageCount = 0
        }
        
        for outfit in outfits {
            for tagName in outfit.tags {
                if let index = tags.firstIndex(where: { $0.name == tagName }) {
                    tags[index].usageCount += 1
                }
            }
        }
        
        tags.removeAll { $0.usageCount == 0 }
    }
    
    var filteredOutfits: [OutfitEntry] {
        if searchText.isEmpty {
            return outfits.sorted { $0.date > $1.date }
        } else {
            return outfits.filter { outfit in
                outfit.description.localizedCaseInsensitiveContains(searchText) ||
                outfit.notes.localizedCaseInsensitiveContains(searchText) ||
                outfit.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }.sorted { $0.date > $1.date }
        }
    }
    
    var sortedTags: [Tag] {
        tags.sorted { $0.usageCount > $1.usageCount }
    }
    
    var averageComfort: Double {
        guard !outfits.isEmpty else { return 0 }
        let total = outfits.reduce(0) { $0 + $1.comfort }
        return Double(total) / Double(outfits.count)
    }
    
    var moodDistribution: [Mood: Int] {
        var distribution: [Mood: Int] = [:]
        for mood in Mood.allCases {
            distribution[mood] = 0
        }
        
        for outfit in outfits {
            distribution[outfit.mood, default: 0] += 1
        }
        
        return distribution
    }
    
    var reactionDistribution: [Reaction: Int] {
        var distribution: [Reaction: Int] = [:]
        for reaction in Reaction.allCases {
            distribution[reaction] = 0
        }
        
        for outfit in outfits {
            distribution[outfit.reaction, default: 0] += 1
        }
        
        return distribution
    }
    
    var topOutfits: [OutfitEntry] {
        outfits.sorted { $0.comfort > $1.comfort }.prefix(3).map { $0 }
    }
    
    var mostUsedTags: [Tag] {
        sortedTags.prefix(5).map { $0 }
    }
}

class AppStateViewModel: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var showingSplash = true
    @Published var showingOnboarding = false
    
    init() {
        checkFirstLaunch()
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !UserDefaults.standard.bool(forKey: "HasLaunchedBefore")
        if isFirstLaunch {
            showingOnboarding = true
        }
    }
    
    func completeSplash() {
        showingSplash = false
    }
    
    func completeOnboarding() {
        showingOnboarding = false
        UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
        isFirstLaunch = false
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

