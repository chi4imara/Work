import Foundation
import SwiftUI
import StoreKit
import Combine

class AppViewModel: ObservableObject {
    @Published var showSplash = true
    @Published var showOnboarding = UserDefaults.standard.bool(forKey: "onboarding_completed")
    @Published var isOnboardingCompleted = false
    
    init() {
        checkOnboardingStatus()
    }
    
    func completeSplash() {
        showSplash = false
        if !isOnboardingCompleted {
            showOnboarding = true
        }
    }
    
    func completeOnboarding() {
        showOnboarding = true
        isOnboardingCompleted = true
        UserDefaults.standard.set(true, forKey: "onboarding_completed")
    }
    
    private func checkOnboardingStatus() {
        isOnboardingCompleted = UserDefaults.standard.bool(forKey: "onboarding_completed")
    }
}

class RecommendationsViewModel: ObservableObject {
    @Published var foods: [Food] = []
    @Published var filteredFoods: [Food] = []
    @Published var filterOptions = FilterOptions()
    @Published var showingFilters = false

    private let foodsKey = "saved_recommendation_foods"
    var onAddToMealPlan: ((Food) -> Void)?

    init(onAddToMealPlan: ((Food) -> Void)? = nil) {
        self.onAddToMealPlan = onAddToMealPlan
        loadFoods()
        applyFilters()
    }

    func applyFilters() {
        if filterOptions.isEmpty {
            filteredFoods = foods
        } else {
            filteredFoods = foods.filter { filterOptions.matches(food: $0) }
        }
    }

    func resetFilters() {
        filterOptions = FilterOptions()
        applyFilters()
    }

    func addToMealPlan(food: Food) {
        onAddToMealPlan?(food)
    }

    func addFood(_ food: Food) {
        foods.append(food)
        applyFilters()
        saveFoods()
    }

    func removeFood(id: UUID) {
        foods.removeAll { $0.id == id }
        applyFilters()
        saveFoods()
    }

    private func saveFoods() {
        if let encoded = try? JSONEncoder().encode(foods) {
            UserDefaults.standard.set(encoded, forKey: foodsKey)
        }
    }

    private func loadFoods() {
        if let data = UserDefaults.standard.data(forKey: foodsKey),
           let decoded = try? JSONDecoder().decode([Food].self, from: data) {
            foods = decoded
        }
    }
}

class MealPlanViewModel: ObservableObject {
    @Published var mealEntries: [MealEntry] = []
    @Published var selectedDate = Date()

    private let mealEntriesKey = "saved_meal_entries"

    init() {
        loadMealEntries()
    }

    var todaysMeals: [MealEntry] {
        let calendar = Calendar.current
        return mealEntries.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }

    var totalCaloriesToday: Int {
        todaysMeals.filter { $0.status == .consumed }.reduce(0) { $0 + $1.food.calories }
    }

    func addMealEntry(_ entry: MealEntry) {
        mealEntries.append(entry)
        saveMealEntries()
    }

    func updateMealStatus(_ entryId: UUID, status: MealStatus) {
        if let index = mealEntries.firstIndex(where: { $0.id == entryId }) {
            mealEntries[index].status = status
            saveMealEntries()
        }
    }

    func removeMealEntry(_ entryId: UUID) {
        mealEntries.removeAll { $0.id == entryId }
        saveMealEntries()
    }

    private func saveMealEntries() {
        if let encoded = try? JSONEncoder().encode(mealEntries) {
            UserDefaults.standard.set(encoded, forKey: mealEntriesKey)
        }
    }

    private func loadMealEntries() {
        if let data = UserDefaults.standard.data(forKey: mealEntriesKey),
           let decoded = try? JSONDecoder().decode([MealEntry].self, from: data) {
            mealEntries = decoded
        }
    }
}

class ProgressViewModel: ObservableObject {
    @Published var energyData: [EnergyData] = []
    @Published var selectedTimeRange: TimeRange = .week

    private let energyDataKey = "saved_energy_data"

    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }

    init() {
        loadEnergyData()
    }

    var filteredEnergyData: [EnergyData] {
        let calendar = Calendar.current
        let now = Date()

        switch selectedTimeRange {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            return energyData.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return energyData.filter { $0.date >= monthAgo }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            return energyData.filter { $0.date >= yearAgo }
        }
    }

    var averageEnergyLevel: Double {
        let data = filteredEnergyData
        guard !data.isEmpty else { return 0 }
        return data.reduce(0) { $0 + $1.energyLevel } / Double(data.count)
    }

    func goalsDistributionPercentages(mealEntries: [MealEntry]) -> (energy: Int, focus: Int, relax: Int) {
        guard !mealEntries.isEmpty else { return (0, 0, 0) }
        let total = mealEntries.count
        let energy = mealEntries.filter { $0.food.goal == .energy }.count
        let focus = mealEntries.filter { $0.food.goal == .focus }.count
        let relax = mealEntries.filter { $0.food.goal == .relax }.count
        return (
            total > 0 ? Int((Double(energy) / Double(total)) * 100) : 0,
            total > 0 ? Int((Double(focus) / Double(total)) * 100) : 0,
            total > 0 ? Int((Double(relax) / Double(total)) * 100) : 0
        )
    }

    func computedAchievements(mealEntries: [MealEntry]) -> [Achievement] {
        let consumed = mealEntries.filter { $0.status == .consumed }
        let consumedCount = consumed.count
        let totalMeals = mealEntries.count
        let energyEntriesCount = energyData.count

        let calendar = Calendar.current
        var consecutiveBalancedDays = 0
        if !consumed.isEmpty {
            let sortedDates = consumed.map { calendar.startOfDay(for: $0.date) }
            let uniqueDays = Set(sortedDates).sorted()
            var current = 0
            for (i, day) in uniqueDays.enumerated() {
                if i == 0 {
                    current = 1
                } else {
                    let prev = uniqueDays[i - 1]
                    if let nextDay = calendar.date(byAdding: .day, value: 1, to: prev), nextDay == day {
                        current += 1
                    } else {
                        current = 1
                    }
                }
                consecutiveBalancedDays = max(consecutiveBalancedDays, current)
            }
        }

        let highEnergyDays = energyData.filter { $0.energyLevel >= 7 }.count
        let energyGoalCount = mealEntries.filter { $0.food.goal == .energy }.count
        let focusGoalCount = mealEntries.filter { $0.food.goal == .focus }.count
        let relaxGoalCount = mealEntries.filter { $0.food.goal == .relax }.count

        return [
            Achievement(id: "first_meal", title: "First Meal", description: "Add your first meal to the diet", isUnlocked: totalMeals >= 1, date: totalMeals >= 1 ? Date() : nil),
            Achievement(id: "three_balanced", title: "3 Days Balanced", description: "Maintained nutrition for 3 consecutive days", isUnlocked: consecutiveBalancedDays >= 3, date: consecutiveBalancedDays >= 3 ? Date() : nil),
            Achievement(id: "five_energy", title: "Energy Boost", description: "Logged 5 high energy days (7+)", isUnlocked: highEnergyDays >= 5, date: highEnergyDays >= 5 ? Date() : nil),
            Achievement(id: "ten_meals", title: "10 Meals", description: "Added 10 meals to your diet", isUnlocked: totalMeals >= 10, date: totalMeals >= 10 ? Date() : nil),
            Achievement(id: "five_consumed", title: "5 Consumed", description: "Marked 5 meals as consumed", isUnlocked: consumedCount >= 5, date: consumedCount >= 5 ? Date() : nil),
            Achievement(id: "energy_meals", title: "Energy Focus", description: "Added 5 energy goal meals", isUnlocked: energyGoalCount >= 5, date: energyGoalCount >= 5 ? Date() : nil),
            Achievement(id: "focus_meals", title: "Focus Master", description: "Added 5 focus goal meals", isUnlocked: focusGoalCount >= 5, date: focusGoalCount >= 5 ? Date() : nil),
            Achievement(id: "relax_meals", title: "Relaxation Expert", description: "Added 5 relax goal meals", isUnlocked: relaxGoalCount >= 5, date: relaxGoalCount >= 5 ? Date() : nil),
            Achievement(id: "energy_log", title: "Energy Tracker", description: "Logged 3 energy entries", isUnlocked: energyEntriesCount >= 3, date: energyEntriesCount >= 3 ? Date() : nil)
        ]
    }

    func addEnergyData(_ data: EnergyData) {
        energyData.append(data)
        energyData.sort { $0.date < $1.date }
        saveEnergyData()
    }

    func updateEnergyData(id: UUID, newData: EnergyData) {
        if let index = energyData.firstIndex(where: { $0.id == id }) {
            energyData[index] = EnergyData(id: id, date: newData.date, energyLevel: newData.energyLevel, mood: newData.mood)
            energyData.sort { $0.date < $1.date }
            saveEnergyData()
        }
    }

    func removeEnergyData(id: UUID) {
        energyData.removeAll { $0.id == id }
        saveEnergyData()
    }

    private func saveEnergyData() {
        if let encoded = try? JSONEncoder().encode(energyData) {
            UserDefaults.standard.set(encoded, forKey: energyDataKey)
        }
    }

    private func loadEnergyData() {
        if let data = UserDefaults.standard.data(forKey: energyDataKey),
           let decoded = try? JSONDecoder().decode([EnergyData].self, from: data) {
            energyData = decoded.sorted { $0.date < $1.date }
        }
    }
}

class ProfileViewModel: ObservableObject {
    @Published var userProfile = UserProfile()
    @Published var isEditing = false
    @Published var showSaveSuccess = false
    
    private let profileKey = "saved_user_profile"
    
    init() {
        loadProfile()
    }
    
    func saveProfile() {
        if let encoded = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
            UserDefaults.standard.synchronize()
            isEditing = false
            showSaveSuccess = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.showSaveSuccess = false
            }
        }
    }
    
    func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = decoded
        }
    }
    
    func addAllergy(_ allergy: String) {
        if !allergy.isEmpty && !userProfile.allergies.contains(allergy) {
            userProfile.allergies.append(allergy)
        }
    }
    
    func removeAllergy(_ allergy: String) {
        userProfile.allergies.removeAll { $0 == allergy }
    }
    
    func addPreference(_ preference: String) {
        if !preference.isEmpty && !userProfile.preferences.contains(preference) {
            userProfile.preferences.append(preference)
        }
    }
    
    func removePreference(_ preference: String) {
        userProfile.preferences.removeAll { $0 == preference }
    }
}

class SettingsViewModel: ObservableObject {
    @Published var showingRateApp = false
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://www.privacypolicies.com/live/8e2da516-f519-4c19-8f07-fa9f942761da") {
            UIApplication.shared.open(url)
        }
    }
    
    func openContactEmail() {
        if let url = URL(string: "https://www.privacypolicies.com/live/8e2da516-f519-4c19-8f07-fa9f942761da") {
            UIApplication.shared.open(url)
        }
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

class AddMealViewModel: ObservableObject {
    @Published var mealName = ""
    @Published var selectedMealType: MealType = .breakfast
    @Published var selectedGoal: MoodGoal = .energy
    @Published var calories = ""
    @Published var selectedDate = Date()
    @Published var selectedTime = Date()
    
    var isValid: Bool {
        !mealName.isEmpty && !calories.isEmpty && Int(calories) != nil
    }
    
    func createMealEntry() -> MealEntry? {
        guard isValid, let calorieCount = Int(calories) else { return nil }
        
        let food = Food(
            name: mealName,
            type: selectedMealType,
            calories: calorieCount,
            goal: selectedGoal,
            description: "Custom meal",
            ingredients: []
        )
        
        return MealEntry(
            food: food,
            date: selectedDate,
            status: .planned,
            plannedTime: selectedTime
        )
    }
    
    func reset() {
        mealName = ""
        selectedMealType = .breakfast
        selectedGoal = .energy
        calories = ""
        selectedDate = Date()
        selectedTime = Date()
    }
}
