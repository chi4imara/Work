import SwiftUI

struct MealDetailItem: Identifiable {
    let id: UUID
}

struct MenuView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    @ObservedObject var mealPlanViewModel: MealPlanViewModel
    @State private var selectedDate = Date()
    @State private var showingAddMeal = false
    @State private var addMealCategory: Recipe.MealCategory = .breakfast
    @State private var showingCalendar = false
    @State private var selectedMealId: MealDetailItem?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridPattern()
                .opacity(0.2)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    
                    nutritionSummaryView
                    
                    mealsView
                    
                    addMealButton
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 180)
            }
        }
        .sheet(isPresented: $showingAddMeal) {
            AddMealView(recipeViewModel: recipeViewModel, initialCategory: addMealCategory) { recipe, category in
                mealPlanViewModel.addMeal(recipe, category: category, date: selectedDate)
            }
        }
        .sheet(item: $selectedMealId) { item in
            MealDetailView(
                mealId: item.id,
                mealProvider: { mealPlanViewModel.meal(byId: $0) },
                onUpdate: { mealPlanViewModel.updateMeal($0) },
                onRemove: { mealPlanViewModel.removeMeal($0) }
            )
        }
        .sheet(isPresented: $showingCalendar) {
            CalendarDatePickerView(selectedDate: $selectedDate) {
                showingCalendar = false
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("My Menu")
                    .font(AppFonts.title(28))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<7) { dayOffset in
                        let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) ?? Date()
                        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                        
                        Button(action: { selectedDate = date }) {
                            VStack(spacing: 4) {
                                Text(dayName(for: date))
                                    .font(AppFonts.caption(12))
                                    .foregroundColor(isSelected ? .black : AppColors.textSecondary)
                                
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(AppFonts.subtitle(16))
                                    .foregroundColor(isSelected ? .black : AppColors.textPrimary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(isSelected ? AppColors.primaryYellow : AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(isSelected ? AppColors.primaryYellow : AppColors.cardBorder, lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, -16)
        }
    }
    
    private var nutritionSummaryView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Daily Summary")
                    .font(AppFonts.subtitle(18))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Text(dateFormatter.string(from: selectedDate))
                    .font(AppFonts.caption(14))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            let mealPlan = mealPlanViewModel.currentMealPlan
            if mealPlan.meals.isEmpty {
                Text("No meals planned for this day")
                    .font(AppFonts.body(16))
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.vertical, 20)
            } else {
                HStack(spacing: 0) {
                    nutritionItem(
                        title: "Calories",
                        value: "\(mealPlan.totalCalories)",
                        unit: "kcal",
                        color: AppColors.primaryYellow
                    )
                    
                    Divider()
                        .frame(height: 40)
                        .background(AppColors.cardBorder)
                    
                    nutritionItem(
                        title: "Protein",
                        value: "\(Int(mealPlan.totalMacros.protein))",
                        unit: "g",
                        color: AppColors.secondaryGreen
                    )
                    
                    Divider()
                        .frame(height: 40)
                        .background(AppColors.cardBorder)
                    
                    nutritionItem(
                        title: "Carbs",
                        value: "\(Int(mealPlan.totalMacros.carbs))",
                        unit: "g",
                        color: AppColors.secondaryOrange
                    )
                    
                    Divider()
                        .frame(height: 40)
                        .background(AppColors.cardBorder)
                    
                    nutritionItem(
                        title: "Fat",
                        value: "\(Int(mealPlan.totalMacros.fat))",
                        unit: "g",
                        color: AppColors.secondaryPink
                    )
                }
                .padding(.vertical, 16)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var mealsView: some View {
        VStack(spacing: 16) {
            ForEach(Recipe.MealCategory.allCases, id: \.self) { category in
                mealCategorySection(category: category)
            }
        }
    }
    
    private func mealCategorySection(category: Recipe.MealCategory) -> some View {
        let meals = mealPlanViewModel.currentMealPlan.meals.filter { $0.category == category }
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: iconForCategory(category))
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.primaryYellow)
                
                Text(category.rawValue)
                    .font(AppFonts.subtitle(18))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button(action: {
                    addMealCategory = category
                    showingAddMeal = true
                }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 18))
                        .foregroundColor(AppColors.primaryYellow)
                }
            }
            
            if meals.isEmpty {
                emptyMealView(category: category)
            } else {
                ForEach(meals) { meal in
                    MealCard(meal: meal) {
                        selectedMealId = MealDetailItem(id: meal.id)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func emptyMealView(category: Recipe.MealCategory) -> some View {
        Button(action: {
            addMealCategory = category
            showingAddMeal = true
        }) {
            HStack {
                Image(systemName: "plus")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.textSecondary)
                
                Text("Add \(category.rawValue.lowercased())")
                    .font(AppFonts.body(16))
                    .foregroundColor(AppColors.textSecondary)
                
                Spacer()
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [5]))
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var addMealButton: some View {
        Button(action: {
            addMealCategory = .breakfast
            showingAddMeal = true
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20))
                
                Text("Add Meal")
                    .font(AppFonts.button(16))
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                    .fill(AppColors.primaryYellow)
            )
        }
    }
    
    private func nutritionItem(title: String, value: String, unit: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(title)
                .font(AppFonts.caption(12))
                .foregroundColor(AppColors.textSecondary)
            
            HStack(alignment: .bottom, spacing: 2) {
                Text(value)
                    .font(AppFonts.subtitle(16))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(unit)
                    .font(AppFonts.caption(10))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func dayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    private func iconForCategory(_ category: Recipe.MealCategory) -> String {
        switch category {
        case .breakfast:
            return "sunrise"
        case .lunch:
            return "sun.max"
        case .dinner:
            return "moon"
        case .snack:
            return "leaf"
        }
    }
}

struct MealCard: View {
    let meal: PlannedMeal
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(meal.recipe.name)
                        .font(AppFonts.subtitle(16))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(2)
                    
                    HStack {
                        Label("\(meal.recipe.cookingTime)m", systemImage: "clock")
                        Spacer()
                        Label("\(meal.recipe.calories)", systemImage: "flame")
                    }
                    .font(AppFonts.caption(12))
                    .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    statusIcon(for: meal.status)
                    
                    Text(meal.status.rawValue)
                        .font(AppFonts.caption(10))
                        .foregroundColor(statusColor(for: meal.status))
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func statusIcon(for status: PlannedMeal.MealStatus) -> some View {
        Image(systemName: {
            switch status {
            case .planned:
                return "clock"
            case .cooked:
                return "checkmark.circle.fill"
            case .skipped:
                return "xmark.circle.fill"
            }
        }())
        .font(.system(size: 16))
        .foregroundColor(statusColor(for: status))
    }
    
    private func statusColor(for status: PlannedMeal.MealStatus) -> Color {
        switch status {
        case .planned:
            return AppColors.primaryYellow
        case .cooked:
            return AppColors.secondaryGreen
        case .skipped:
            return AppColors.secondaryPink
        }
    }
}

struct CalendarDatePickerView: View {
    @Binding var selectedDate: Date
    let onDone: () -> Void
    
    @State private var tempDate: Date
    
    init(selectedDate: Binding<Date>, onDone: @escaping () -> Void) {
        self._selectedDate = selectedDate
        self.onDone = onDone
        self._tempDate = State(initialValue: selectedDate.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridPattern()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        DatePicker(
                            "Select date",
                            selection: $tempDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .tint(AppColors.primaryYellow)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 16)
                        
                        Button(action: {
                            selectedDate = tempDate
                            onDone()
                        }) {
                            Text("Save")
                                .font(AppFonts.button(18))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                        .fill(AppColors.primaryYellow)
                                )
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        selectedDate = tempDate
                        onDone()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    MenuView(recipeViewModel: RecipeViewModel(), mealPlanViewModel: MealPlanViewModel())
}
