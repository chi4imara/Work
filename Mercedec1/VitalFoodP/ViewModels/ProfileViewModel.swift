import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile
    @Published var availableGoals = ["Weight Loss", "Muscle Gain", "Energy Boost", "Better Sleep", "Stress Relief", "Focus Enhancement"]
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "user_profile"),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = profile
        } else {
            userProfile = UserProfile()
        }
    }
    
    func saveProfile() {
        if let data = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(data, forKey: "user_profile")
        }
    }
    
    func toggleGoal(_ goal: String) {
        if userProfile.goals.contains(goal) {
            userProfile.goals.removeAll { $0 == goal }
        } else {
            userProfile.goals.append(goal)
        }
        saveProfile()
    }
    
    func updateDietType(_ dietType: DietType) {
        userProfile.dietType = dietType
        saveProfile()
    }
    
    func updateNotifications(_ enabled: Bool) {
        userProfile.notifications = enabled
        saveProfile()
    }
    
    func updateName(_ name: String) {
        userProfile.name = name
        saveProfile()
    }
    
    func updateEmail(_ email: String) {
        userProfile.email = email
        saveProfile()
    }
}
