import Foundation
import SwiftUI
import StoreKit
import Combine

class AppViewModel: ObservableObject {
    @Published var appState = AppState()
    @Published var isShowingSplash = true
    @Published var selectedTab = 0
    
    init() {
        loadAppState()
    }
    
    func completeOnboarding() {
        appState.hasCompletedOnboarding = true
        saveAppState()
    }
    
    private func loadAppState() {
        if let data = UserDefaults.standard.data(forKey: "AppState"),
           let state = try? JSONDecoder().decode(AppState.self, from: data) {
            self.appState = state
        }
    }
    
    private func saveAppState() {
        if let data = try? JSONEncoder().encode(appState) {
            UserDefaults.standard.set(data, forKey: "AppState")
        }
    }
}

class TodayViewModel: ObservableObject {
    @Published var dailyChallenge: Challenge?
    @Published var waterIntake = WaterIntake()
    @Published var dailyProgress = DailyProgress(date: Date())
    
    private let userDefaults = UserDefaults.standard
    private let calendar = Calendar.current
    
    init() {
        loadTodayData()
        loadOrGenerateDailyChallenge()
    }
    
    var greetingText: String {
        let hour = calendar.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
    
    func completeDailyChallenge() {
        guard var challenge = dailyChallenge, !challenge.isCompleted else { return }
        
        challenge.isCompleted = true
        challenge.completedDate = Date()
        challenge.currentValue = challenge.targetValue
        dailyChallenge = challenge
        dailyProgress.challengesCompleted += 1
        
        saveTodayData()
    }
    
    func addWater(amount: Int) {
        waterIntake.currentAmount += amount
        dailyProgress.waterIntake = waterIntake
        saveTodayData()
    }
    
    private func todayDateKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func loadOrGenerateDailyChallenge() {
        let key = "DailyChallenge_\(todayDateKey())"
        if let data = userDefaults.data(forKey: key),
           let challenge = try? JSONDecoder().decode(Challenge.self, from: data) {
            dailyChallenge = challenge
        } else {
            generateDailyChallenge()
        }
    }
    
    private func generateDailyChallenge() {
        let challenges = [
            Challenge(name: "10,000 Steps", description: "Take 10,000 steps today", targetValue: 10000, unit: "steps"),
            Challenge(name: "5 Minute Plank", description: "Hold a plank for 5 minutes total", targetValue: 5, unit: "minutes"),
            Challenge(name: "Write Daily Goal", description: "Write down your main goal for today", targetValue: 1, unit: "goal"),
            Challenge(name: "Drink 8 Glasses", description: "Drink 8 glasses of water", targetValue: 8, unit: "glasses"),
            Challenge(name: "30 Push-ups", description: "Complete 30 push-ups", targetValue: 30, unit: "reps")
        ]
        
        dailyChallenge = challenges.randomElement()
        saveDailyChallenge()
    }
    
    private func loadTodayData() {
        if let data = userDefaults.data(forKey: "TodayWater"),
           let water = try? JSONDecoder().decode(WaterIntake.self, from: data) {
            self.waterIntake = water
        }
        
        if let data = userDefaults.data(forKey: "TodayProgress"),
           let progress = try? JSONDecoder().decode(DailyProgress.self, from: data) {
            self.dailyProgress = progress
        }
    }
    
    private func saveTodayData() {
        if let data = try? JSONEncoder().encode(waterIntake) {
            userDefaults.set(data, forKey: "TodayWater")
        }
        
        if let data = try? JSONEncoder().encode(dailyProgress) {
            userDefaults.set(data, forKey: "TodayProgress")
        }
        
        saveDailyChallenge()
        
        DataManager.shared.refreshTodayProgress(challengesCompleted: dailyProgress.challengesCompleted, waterIntake: waterIntake)
    }
    
    private func saveDailyChallenge() {
        guard let challenge = dailyChallenge else { return }
        let key = "DailyChallenge_\(todayDateKey())"
        if let data = try? JSONEncoder().encode(challenge) {
            userDefaults.set(data, forKey: key)
        }
    }
}

class SettingsViewModel: ObservableObject {
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://www.termsfeed.com/live/76852ca2-21bd-4f49-8e06-77f40d7ebbf9") {
            UIApplication.shared.open(url)
        }
    }
    
    func openContactEmail() {
        if let url = URL(string: "https://www.termsfeed.com/live/76852ca2-21bd-4f49-8e06-77f40d7ebbf9") {
            UIApplication.shared.open(url)
        }
    }
    
    func loadSampleData() {
        DataManager.shared.loadSampleData()
    }
}
