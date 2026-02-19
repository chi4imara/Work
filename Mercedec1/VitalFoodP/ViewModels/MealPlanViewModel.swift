import SwiftUI
import Combine

class MealPlanViewModel: ObservableObject {
    @Published var mealPlan: [MealPlanEntry] = []
    @Published var selectedDate = Date()
    
    init() {
        loadMealPlan()
    }
    
    func addMeal(_ recipe: Recipe, mealTime: MealTime) {
        let entry = MealPlanEntry(recipe: recipe, mealTime: mealTime, date: selectedDate)
        mealPlan.append(entry)
        saveMealPlan()
    }
    
    func removeMeal(_ entry: MealPlanEntry) {
        mealPlan.removeAll { $0.id == entry.id }
        saveMealPlan()
    }
    
    func getMealsForDate(_ date: Date) -> [MealPlanEntry] {
        let calendar = Calendar.current
        return mealPlan.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    func getMealsForMealTime(_ mealTime: MealTime, date: Date) -> [MealPlanEntry] {
        return getMealsForDate(date).filter { $0.mealTime == mealTime }
    }
    
    func getTotalCaloriesForDate(_ date: Date) -> Int {
        return getMealsForDate(date).reduce(0) { $0 + $1.recipe.calories }
    }
    
    private func loadMealPlan() {
        if let data = UserDefaults.standard.data(forKey: "meal_plan"),
           let plan = try? JSONDecoder().decode([MealPlanEntry].self, from: data) {
            mealPlan = plan
        }
    }
    
    private func saveMealPlan() {
        if let data = try? JSONEncoder().encode(mealPlan) {
            UserDefaults.standard.set(data, forKey: "meal_plan")
        }
    }
}
