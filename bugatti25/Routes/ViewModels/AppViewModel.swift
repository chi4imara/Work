import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var dailyTasks: [DailyTask] = []
    @Published var currentChallenge: MiniChallenge?
    @Published var completedChallenges: [MiniChallenge] = []
    @Published var hasCompletedOnboarding: Bool = false
    
    private let defaults = UserDefaults.standard
    private static let placesKey = "wander_places"
    private static let dailyTasksKey = "wander_dailyTasks"
    private static let currentChallengeKey = "wander_currentChallenge"
    private static let completedChallengesKey = "wander_completedChallenges"
    private static let hasCompletedOnboardingKey = "hasCompletedOnboarding"
    
    private static let jsonEncoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .secondsSince1970
        return e
    }()
    
    private static let jsonDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .secondsSince1970
        return d
    }()
    
    init() {
        loadData()
        if currentChallenge == nil {
            setupDailyChallenge()
        }
    }
    
    func loadData() {
        hasCompletedOnboarding = defaults.bool(forKey: Self.hasCompletedOnboardingKey)
        
        if let data = defaults.data(forKey: Self.placesKey),
           let decoded = try? Self.jsonDecoder.decode([Place].self, from: data) {
            places = decoded
        }
        
        if let data = defaults.data(forKey: Self.dailyTasksKey),
           let decoded = try? Self.jsonDecoder.decode([DailyTask].self, from: data) {
            dailyTasks = decoded
        }
        
        if let data = defaults.data(forKey: Self.currentChallengeKey),
           let decoded = try? Self.jsonDecoder.decode(MiniChallenge.self, from: data) {
            currentChallenge = decoded
        }
        
        if let data = defaults.data(forKey: Self.completedChallengesKey),
           let decoded = try? Self.jsonDecoder.decode([MiniChallenge].self, from: data) {
            completedChallenges = decoded
        }
    }
    
    func saveData() {
        defaults.set(hasCompletedOnboarding, forKey: Self.hasCompletedOnboardingKey)
        
        if let data = try? Self.jsonEncoder.encode(places) {
            defaults.set(data, forKey: Self.placesKey)
        }
        
        if let data = try? Self.jsonEncoder.encode(dailyTasks) {
            defaults.set(data, forKey: Self.dailyTasksKey)
        }
        
        if let challenge = currentChallenge, let data = try? Self.jsonEncoder.encode(challenge) {
            defaults.set(data, forKey: Self.currentChallengeKey)
        } else {
            defaults.removeObject(forKey: Self.currentChallengeKey)
        }
        
        if let data = try? Self.jsonEncoder.encode(completedChallenges) {
            defaults.set(data, forKey: Self.completedChallengesKey)
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveData()
    }
    
    func addPlace(_ place: Place) {
        places.append(place)
        saveData()
    }
    
    func updatePlace(_ place: Place) {
        if let index = places.firstIndex(where: { $0.id == place.id }) {
            places[index] = place
            saveData()
        }
    }
    
    func deletePlace(_ place: Place) {
        places.removeAll { $0.id == place.id }
        saveData()
    }
    
    func markPlaceAsCompleted(_ place: Place) {
        if let index = places.firstIndex(where: { $0.id == place.id }) {
            places[index].isCompleted = true
            places[index].completionDate = Date()
            places[index].status = .done
            saveData()
        }
    }
    
    func addTask(_ task: DailyTask) {
        dailyTasks.append(task)
        saveData()
    }
    
    func updateTask(_ task: DailyTask) {
        if let index = dailyTasks.firstIndex(where: { $0.id == task.id }) {
            dailyTasks[index] = task
            saveData()
        }
    }
    
    func deleteTask(_ task: DailyTask) {
        dailyTasks.removeAll { $0.id == task.id }
        saveData()
    }
    
    func markTaskAsCompleted(_ task: DailyTask) {
        if let index = dailyTasks.firstIndex(where: { $0.id == task.id }) {
            dailyTasks[index].isCompleted = true
            dailyTasks[index].completionDate = Date()
            saveData()
        }
    }
    
    func setupDailyChallenge() {
        if currentChallenge == nil {
            currentChallenge = MiniChallenge.dailyChallenges.randomElement()
        }
    }
    
    func completeDailyChallenge() {
        guard let challenge = currentChallenge else { return }
        
        var completedChallenge = challenge
        completedChallenge.isCompleted = true
        completedChallenge.completionDate = Date()
        
        completedChallenges.append(completedChallenge)
        currentChallenge = MiniChallenge.dailyChallenges.randomElement()
        saveData()
    }
    
    var dailyProgress: Double {
        let totalItems = dailyTasks.count + places.count + (currentChallenge != nil ? 1 : 0)
        guard totalItems > 0 else { return 0 }
        
        let challengeCompletedToday: Bool = {
            if currentChallenge?.isCompleted == true { return true }
            let calendar = Calendar.current
            let startOfToday = calendar.startOfDay(for: Date())
            return completedChallenges.contains { challenge in
                guard let date = challenge.completionDate else { return false }
                return calendar.isDate(date, inSameDayAs: startOfToday)
            }
        }()
        
        let completedItems = dailyTasks.filter { $0.isCompleted }.count +
                           places.filter { $0.isCompleted }.count +
                           (challengeCompletedToday ? 1 : 0)
        
        return Double(completedItems) / Double(totalItems)
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return "Good morning"
        case 12..<18:
            return "Good afternoon"
        default:
            return "Good evening"
        }
    }
        
    func item(by ref: ItemReference) -> AnyItem? {
        switch ref {
        case .place(let id):
            return places.first(where: { $0.id == id }).map { AnyItem.place($0) }
        case .task(let id):
            return dailyTasks.first(where: { $0.id == id }).map { AnyItem.task($0) }
        }
    }
    
    func place(byId id: UUID) -> Place? {
        places.first(where: { $0.id == id })
    }
    
    func task(byId id: UUID) -> DailyTask? {
        dailyTasks.first(where: { $0.id == id })
    }
        
    func loadSampleData() {
        places = SampleData.samplePlacesWithCompletion
        dailyTasks = SampleData.sampleTasksWithCompletion
        currentChallenge = SampleData.sampleCurrentChallenge
        completedChallenges = [SampleData.sampleCompletedChallenge]
        saveData()
    }
}
