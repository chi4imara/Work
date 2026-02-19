import SwiftUI

struct MealPlanView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddMeal = false
    
    var body: some View {
        MealPlanViewContent(
            viewModel: appState.mealPlanViewModel,
            appState: appState,
            showingAddMeal: $showingAddMeal
        )
    }
}

struct MealPlanViewContent: View {
    @ObservedObject var viewModel: MealPlanViewModel
    @ObservedObject var appState: AppState
    @Binding var showingAddMeal: Bool
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        Text("My Day")
                            .font(FontManager.ubuntu(28, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Text(DateFormatter.dayFormatter.string(from: viewModel.selectedDate))
                            .font(FontManager.ubuntu(16, weight: .regular))
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        let totalCalories = viewModel.getTotalCaloriesForDate(viewModel.selectedDate)
                        if totalCalories > 0 {
                            Text("Total: \(totalCalories) calories")
                                .font(FontManager.ubuntu(14, weight: .medium))
                                .foregroundColor(ColorTheme.accentText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.top, 20)
                    
                    let mealsForToday = viewModel.getMealsForDate(viewModel.selectedDate)
                    
                    if mealsForToday.isEmpty {
                        EmptyMealPlanView {
                            showingAddMeal = true
                        }
                        .padding(.top, 50)
                    } else {
                        VStack(spacing: 24) {
                            ForEach(MealTime.allCases, id: \.self) { mealTime in
                                MealTimeSection(
                                    mealTime: mealTime,
                                    meals: viewModel.getMealsForMealTime(mealTime, date: viewModel.selectedDate),
                                    onRemoveMeal: { meal in
                                        viewModel.removeMeal(meal)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    Button(action: { showingAddMeal = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                            Text("Add Meal")
                                .font(FontManager.ubuntu(16, weight: .medium))
                        }
                        .foregroundColor(ColorTheme.buttonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(ColorTheme.buttonBackground)
                        .cornerRadius(25)
                        .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showingAddMeal) {
            AddMealView(mealPlanViewModel: viewModel)
        }
    }
}

struct MealTimeSection: View {
    let mealTime: MealTime
    let meals: [MealPlanEntry]
    let onRemoveMeal: (MealPlanEntry) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: mealTime.icon)
                    .font(.system(size: 20))
                    .foregroundColor(ColorTheme.primaryYellow)
                
                Text(mealTime.rawValue)
                    .font(FontManager.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                if !meals.isEmpty {
                    let totalCalories = meals.reduce(0) { $0 + $1.recipe.calories }
                    Text("\(totalCalories) cal")
                        .font(FontManager.ubuntu(14, weight: .regular))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            
            if meals.isEmpty {
                Text("No meals planned")
                    .font(FontManager.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .padding(.leading, 28)
            } else {
                ForEach(meals) { meal in
                    MealPlanCard(meal: meal, onRemove: { onRemoveMeal(meal) })
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct MealPlanCard: View {
    let meal: MealPlanEntry
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(meal.recipe.mood.color.opacity(0.3))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: meal.recipe.mood.icon)
                        .font(.system(size: 20))
                        .foregroundColor(meal.recipe.mood.color)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.recipe.name)
                    .font(FontManager.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(1)
                
                HStack {
                    Label("\(meal.recipe.calories)", systemImage: "flame.fill")
                        .font(FontManager.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Label("\(meal.recipe.cookingTime)m", systemImage: "clock.fill")
                        .font(FontManager.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(ColorTheme.accentOrange)
            }
        }
        .padding(.leading, 28)
    }
}

struct EmptyMealPlanView: View {
    let onAddMeal: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.secondaryText)
            
            VStack(spacing: 8) {
                Text("Meal plan is empty")
                    .font(FontManager.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Start planning your meals for today")
                    .font(FontManager.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 40)
    }
}

extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()
}

#Preview {
    MealPlanView()
}
