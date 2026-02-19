import Foundation
import SwiftUI
import Combine

class ConversationViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var filteredConversations: [Conversation] = []
    @Published var searchText: String = "" {
        didSet {
            filterConversations()
        }
    }
    
    private let userDefaultsKey = "SavedConversations"
    
    init() {
        loadConversations()
    }
    
    func addConversation(personName: String, topic: String, outcome: String) {
        let newConversation = Conversation(personName: personName, topic: topic, outcome: outcome)
        conversations.insert(newConversation, at: 0) 
        saveConversations()
        filterConversations()
    }
    
    func updateConversation(_ conversation: Conversation, personName: String, topic: String, outcome: String) {
        if let index = conversations.firstIndex(where: { $0.id == conversation.id }) {
            conversations[index].update(personName: personName, topic: topic, outcome: outcome)
            saveConversations()
            filterConversations()
        }
    }
    
    func deleteConversation(_ conversation: Conversation) {
        conversations.removeAll { $0.id == conversation.id }
        saveConversations()
        filterConversations()
    }
    
    func deleteConversation(by id: UUID) {
        conversations.removeAll { $0.id == id }
        saveConversations()
        filterConversations()
    }
    
    func getConversation(by id: UUID) -> Conversation? {
        return conversations.first { $0.id == id }
    }
    
    private func filterConversations() {
        if searchText.isEmpty {
            filteredConversations = conversations
        } else {
            filteredConversations = conversations.filter { conversation in
                conversation.personName.localizedCaseInsensitiveContains(searchText) ||
                conversation.topic.localizedCaseInsensitiveContains(searchText) ||
                conversation.outcome.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func saveConversations() {
        do {
            let data = try JSONEncoder().encode(conversations)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to save conversations: \(error)")
        }
    }
    
    private func loadConversations() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            conversations = []
            filteredConversations = []
            return
        }
        do {
            conversations = try JSONDecoder().decode([Conversation].self, from: data)
            filterConversations()
        } catch {
            print("Failed to load conversations: \(error)")
            conversations = []
            filteredConversations = []
        }
    }
    
    func loadSampleData() {
        conversations = Conversation.sampleData
        saveConversations()
        filterConversations()
    }
    
    var hasConversations: Bool {
        return !conversations.isEmpty
    }
    
    var hasSearchResults: Bool {
        return !filteredConversations.isEmpty
    }
}

class AppStateViewModel: ObservableObject {
    @Published var isFirstLaunch: Bool = true
    @Published var hasCompletedOnboarding: Bool = false
    @Published var isLoading: Bool = true
    
    private let firstLaunchKey = "HasLaunchedBefore"
    private let onboardingKey = "HasCompletedOnboarding"
    
    init() {
        checkFirstLaunch()
        checkOnboardingStatus()
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !UserDefaults.standard.bool(forKey: firstLaunchKey)
    }
    
    private func checkOnboardingStatus() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
    }
    
    func markAsLaunched() {
        UserDefaults.standard.set(true, forKey: firstLaunchKey)
        isFirstLaunch = false
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: onboardingKey)
        hasCompletedOnboarding = true
        markAsLaunched()
    }
    
    func finishLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isLoading = false
        }
    }
}
