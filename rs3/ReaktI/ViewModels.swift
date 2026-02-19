import Foundation
import SwiftUI
import StoreKit
import Combine

class ReactionsViewModel: ObservableObject {
    @Published var reactions: [Reaction] = []
    @Published var filteredReactions: [Reaction] = []
    @Published var selectedFilter: ReactionType? = nil
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let reactionsKey = "SavedReactions"
    
    init() {
        loadReactions()
        updateFilteredReactions()
    }
    
    func addReaction(_ reaction: Reaction) {
        reactions.append(reaction)
        saveReactions()
        updateFilteredReactions()
    }
    
    func updateReaction(_ reaction: Reaction) {
        if let index = reactions.firstIndex(where: { $0.id == reaction.id }) {
            reactions[index] = reaction
            saveReactions()
            updateFilteredReactions()
        }
    }
    
    func deleteReaction(_ reaction: Reaction) {
        reactions.removeAll { $0.id == reaction.id }
        saveReactions()
        updateFilteredReactions()
    }
    
    func setFilter(_ type: ReactionType?) {
        selectedFilter = type
        updateFilteredReactions()
    }
    
    func getStatistics() -> ReactionStatistics {
        return ReactionStatistics(reactions: reactions)
    }
    
    private func loadReactions() {
        if let data = userDefaults.data(forKey: reactionsKey),
           let decodedReactions = try? JSONDecoder().decode([Reaction].self, from: data) {
            reactions = decodedReactions
        }
    }
    
    private func saveReactions() {
        if let encoded = try? JSONEncoder().encode(reactions) {
            userDefaults.set(encoded, forKey: reactionsKey)
        }
    }
    
    private func updateFilteredReactions() {
        if let filter = selectedFilter {
            filteredReactions = reactions.filter { $0.type == filter }
        } else {
            filteredReactions = reactions
        }
    }
}

class AppStateViewModel: ObservableObject {
    @Published var currentTab: TabItem = .reactions
    @Published var showingSplash = true
    @Published var hasCompletedOnboarding = false
    
    private let userDefaults = UserDefaults.standard
    private let onboardingKey = "HasCompletedOnboarding"
    
    init() {
        hasCompletedOnboarding = userDefaults.bool(forKey: onboardingKey)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showingSplash = false
            }
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    func changeTab(to tab: TabItem) {
        currentTab = tab
    }
}

class SettingsViewModel: ObservableObject {
    @Published var showingPrivacyPolicy = false
    @Published var showingContactEmail = false
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://www.privacypolicies.com/live/cda4c715-462b-4d0a-89ea-8d811b9df1ca") {
            UIApplication.shared.open(url)
        }
    }
    
    func openContactEmail() {
        if let url = URL(string: "https://www.privacypolicies.com/live/cda4c715-462b-4d0a-89ea-8d811b9df1ca") {
            UIApplication.shared.open(url)
        }
    }
    
    func requestAppReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

class ReactionFormViewModel: ObservableObject {
    @Published var object: String = ""
    @Published var selectedType: ReactionType = .movie
    @Published var reaction: String = ""
    @Published var comment: String = ""
    
    var isValid: Bool {
        !object.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !reaction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func reset() {
        object = ""
        selectedType = .movie
        reaction = ""
        comment = ""
    }
    
    func populate(with reaction: Reaction) {
        object = reaction.object
        selectedType = reaction.type
        self.reaction = reaction.reaction
        comment = reaction.comment
    }
    
    func createReaction() -> Reaction {
        return Reaction(
            object: object.trimmingCharacters(in: .whitespacesAndNewlines),
            type: selectedType,
            reaction: reaction.trimmingCharacters(in: .whitespacesAndNewlines),
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    func updateReaction(_ reaction: inout Reaction) {
        reaction.update(
            object: object.trimmingCharacters(in: .whitespacesAndNewlines),
            type: selectedType,
            reaction: self.reaction.trimmingCharacters(in: .whitespacesAndNewlines),
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
}
