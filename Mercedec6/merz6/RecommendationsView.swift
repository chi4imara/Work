import SwiftUI

struct RecommendationsView: View {
    @EnvironmentObject var mealPlanViewModel: MealPlanViewModel
    @StateObject private var viewModel: RecommendationsViewModel
    @State private var showingAddFood = false
    
    init() {
        _viewModel = StateObject(wrappedValue: RecommendationsViewModel())
    }
    
    var body: some View {
        ZStack {
            AppGradients.primaryBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerSection
                    
                    filtersSection
                    
                    if viewModel.foods.isEmpty {
                        emptyListStateView
                    } else if viewModel.filteredFoods.isEmpty {
                        emptyFilteredStateView
                    } else {
                        foodCardsSection
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.sm)
                .padding(.bottom, 120)
            }
        }
        .onAppear {
            viewModel.onAddToMealPlan = { food in
                let mealEntry = MealEntry(food: food, date: Date(), status: .planned)
                mealPlanViewModel.addMealEntry(mealEntry)
            }
        }
        .sheet(isPresented: $viewModel.showingFilters) {
            FiltersSheet(filterOptions: $viewModel.filterOptions) {
                viewModel.applyFilters()
            }
        }
        .sheet(isPresented: $showingAddFood) {
            AddFoodView { food in
                viewModel.addFood(food)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.sm) {
            Text("Today's Recommendations")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            Text("Choose meals based on your mood and energy")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
    }
    
    private var filtersSection: some View {
        HStack {
            Button(action: {
                viewModel.showingFilters = true
            }) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                    Text("Filters")
                }
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.medium)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.medium)
                                .stroke(AppColors.cardBorder, lineWidth: 1)
                        )
                )
            }
            
            Spacer()
            
            Button(action: { showingAddFood = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add meal")
                }
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.medium)
                        .fill(AppColors.accentYellow)
                )
            }
            
            if !viewModel.filterOptions.isEmpty {
                Button("Reset") {
                    viewModel.resetFilters()
                }
                .font(AppFonts.body)
                .foregroundColor(AppColors.accentText)
            }
        }
    }
    
    private var foodCardsSection: some View {
        LazyVStack(spacing: AppSpacing.md) {
            ForEach(viewModel.filteredFoods) { food in
                FoodCard(food: food) {
                    viewModel.addToMealPlan(food: food)
                }
            }
        }
    }
    
    private var emptyListStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: AppSpacing.sm) {
                Text("No meals yet")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first meal suggestion to get started")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, AppSpacing.xxl)
    }
    
    private var emptyFilteredStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: AppSpacing.sm) {
                Text("No suitable meals found")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Try adjusting your filters or reset them to see all options")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button("Reset Filters") {
                viewModel.resetFilters()
            }
            .font(AppFonts.body)
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.medium)
                    .fill(AppColors.accentYellow)
            )
        }
        .padding(.vertical, AppSpacing.xxl)
    }
}

struct FoodCard: View {
    let food: Food
    let onAddToMealPlan: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(food.name)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    HStack {
                        Text(food.type.rawValue)
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("•")
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("\(food.calories) cal")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                Spacer()
                
                Text(food.goal.rawValue)
                    .font(AppFonts.small)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, AppSpacing.xs)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.small)
                            .fill(goalColor(for: food.goal))
                    )
            }
            
            Text(food.description)
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .lineLimit(2)
            
            if !food.ingredients.isEmpty {
                HStack {
                    Text("Ingredients:")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(food.ingredients.prefix(3).joined(separator: ", "))
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(1)
                    
                    if food.ingredients.count > 3 {
                        Text("...")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            
            Button(action: onAddToMealPlan) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add to Diet")
                }
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.medium)
                        .fill(AppColors.accentYellow)
                )
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.large)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.large)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func goalColor(for goal: MoodGoal) -> Color {
        switch goal {
        case .energy: return AppColors.energyColor
        case .focus: return Color.green
        case .relax: return AppColors.relaxColor
        }
    }
}

struct FiltersSheet: View {
    @Binding var filterOptions: FilterOptions
    @Environment(\.dismiss) private var dismiss
    let onApply: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        filterSection(title: "Goal") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: AppSpacing.sm) {
                                ForEach(MoodGoal.allCases) { goal in
                                    Button(goal.rawValue) {
                                        filterOptions.selectedGoal = filterOptions.selectedGoal == goal ? nil : goal
                                    }
                                    .font(AppFonts.body)
                                    .foregroundColor(filterOptions.selectedGoal == goal ? AppColors.primaryText : AppColors.secondaryText)
                                    .padding(.horizontal, AppSpacing.md)
                                    .padding(.vertical, AppSpacing.sm)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: AppRadius.medium)
                                            .fill(filterOptions.selectedGoal == goal ? AppColors.accentYellow : AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: AppRadius.medium)
                                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                                            )
                                    )
                                }
                            }
                        }
                        
                        filterSection(title: "Meal Type") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppSpacing.sm) {
                                ForEach(MealType.allCases) { type in
                                    Button(type.rawValue) {
                                        filterOptions.selectedMealType = filterOptions.selectedMealType == type ? nil : type
                                    }
                                    .font(AppFonts.body)
                                    .foregroundColor(filterOptions.selectedMealType == type ? AppColors.primaryText : AppColors.secondaryText)
                                    .padding(.horizontal, AppSpacing.md)
                                    .padding(.vertical, AppSpacing.sm)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: AppRadius.medium)
                                            .fill(filterOptions.selectedMealType == type ? AppColors.accentYellow : AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: AppRadius.medium)
                                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                                            )
                                    )
                                }
                            }
                        }
                    }
                    .padding(AppSpacing.md)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        onApply()
                        dismiss()
                    }
                    .foregroundColor(AppColors.accentText)
                }
            }
        }
    }
    
    private func filterSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            content()
        }
    }
}

#Preview {
    RecommendationsView()
}
