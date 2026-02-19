import SwiftUI

struct FiltersView: View {
    @Binding var filters: RecipeFilters
    let onApply: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempFilters: RecipeFilters
    
    init(filters: Binding<RecipeFilters>, onApply: @escaping () -> Void) {
        self._filters = filters
        self.onApply = onApply
        self._tempFilters = State(initialValue: filters.wrappedValue)
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
                        filterSection(title: "Nutrition Goals") {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(User.NutritionGoal.allCases, id: \.self) { goal in
                                    FilterChip(
                                        title: goal.rawValue,
                                        isSelected: tempFilters.goals.contains(goal)
                                    ) {
                                        if tempFilters.goals.contains(goal) {
                                            tempFilters.goals.remove(goal)
                                        } else {
                                            tempFilters.goals.insert(goal)
                                        }
                                    }
                                }
                            }
                        }
                        
                        filterSection(title: "Meal Type") {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(Recipe.MealCategory.allCases, id: \.self) { category in
                                    FilterChip(
                                        title: category.rawValue,
                                        isSelected: tempFilters.mealTypes.contains(category)
                                    ) {
                                        if tempFilters.mealTypes.contains(category) {
                                            tempFilters.mealTypes.remove(category)
                                        } else {
                                            tempFilters.mealTypes.insert(category)
                                        }
                                    }
                                }
                            }
                        }
                        
                        filterSection(title: "Difficulty Level") {
                            VStack(spacing: 12) {
                                ForEach(Recipe.Difficulty.allCases, id: \.self) { difficulty in
                                    FilterChip(
                                        title: difficulty.rawValue,
                                        isSelected: tempFilters.difficulty == difficulty,
                                        fullWidth: true
                                    ) {
                                        tempFilters.difficulty = tempFilters.difficulty == difficulty ? nil : difficulty
                                    }
                                }
                            }
                        }
                        
                        filterSection(title: "Cooking Time") {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Max: \(tempFilters.maxCookingTime ?? 120) minutes")
                                        .font(AppFonts.body(16))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Spacer()
                                    
                                    if tempFilters.maxCookingTime != nil {
                                        Button("Clear") {
                                            tempFilters.maxCookingTime = nil
                                        }
                                        .font(AppFonts.caption(14))
                                        .foregroundColor(AppColors.primaryYellow)
                                    }
                                }
                                
                                Slider(
                                    value: Binding(
                                        get: { Double(tempFilters.maxCookingTime ?? 120) },
                                        set: { tempFilters.maxCookingTime = Int($0) }
                                    ),
                                    in: 5...120,
                                    step: 5
                                )
                                .tint(AppColors.primaryYellow)
                            }
                        }
                        
                        filterSection(title: "Calories Range") {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Min: \(tempFilters.minCalories ?? 0)")
                                        .font(AppFonts.body(14))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Spacer()
                                    
                                    Text("Max: \(tempFilters.maxCalories ?? 1000)")
                                        .font(AppFonts.body(14))
                                        .foregroundColor(AppColors.textPrimary)
                                }
                                
                                HStack(spacing: 16) {
                                    VStack {
                                        Slider(
                                            value: Binding(
                                                get: { Double(tempFilters.minCalories ?? 0) },
                                                set: { tempFilters.minCalories = Int($0) }
                                            ),
                                            in: 0...500,
                                            step: 25
                                        )
                                        .tint(AppColors.secondaryGreen)
                                        
                                        Text("Min")
                                            .font(AppFonts.caption(12))
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    
                                    VStack {
                                        Slider(
                                            value: Binding(
                                                get: { Double(tempFilters.maxCalories ?? 1000) },
                                                set: { tempFilters.maxCalories = Int($0) }
                                            ),
                                            in: 200...1000,
                                            step: 25
                                        )
                                        .tint(AppColors.secondaryOrange)
                                        
                                        Text("Max")
                                            .font(AppFonts.caption(12))
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                }
                                
                                if tempFilters.minCalories != nil || tempFilters.maxCalories != nil {
                                    Button("Clear Range") {
                                        tempFilters.minCalories = nil
                                        tempFilters.maxCalories = nil
                                    }
                                    .font(AppFonts.caption(14))
                                    .foregroundColor(AppColors.primaryYellow)
                                }
                            }
                        }
                        
                        filterSection(title: "Dietary Preferences") {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(User.DietaryPreference.allCases, id: \.self) { preference in
                                    FilterChip(
                                        title: preference.rawValue,
                                        isSelected: tempFilters.dietaryPreferences.contains(preference)
                                    ) {
                                        if tempFilters.dietaryPreferences.contains(preference) {
                                            tempFilters.dietaryPreferences.remove(preference)
                                        } else {
                                            tempFilters.dietaryPreferences.insert(preference)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        tempFilters.reset()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
            .preferredColorScheme(.dark)
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 16) {
                    Button {
                        tempFilters.reset()
                        filters = tempFilters
                        onApply()
                        dismiss()
                    } label: {
                        Text("Clear All")
                            .font(AppFonts.button(16))
                            .foregroundColor(AppColors.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
                                    )
                            )

                    }
                    
                    Button {
                        filters = tempFilters
                        onApply()
                        dismiss()
                    } label: {
                        Text("Save")
                            .font(AppFonts.button(16))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                    .fill(AppColors.primaryYellow)
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    AppColors.backgroundGradient
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
    }
    
    private func filterSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            content()
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
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var fullWidth: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.body(14))
                .foregroundColor(isSelected ? .black : AppColors.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppColors.primaryYellow : AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(isSelected ? AppColors.primaryYellow : AppColors.cardBorder, lineWidth: 1)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FiltersView(filters: .constant(RecipeFilters())) {}
}
