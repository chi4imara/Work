import SwiftUI

struct MealPlanView: View {
    @EnvironmentObject var viewModel: MealPlanViewModel
    @State private var showingAddMeal = false
    
    var body: some View {
        ZStack {
            AppGradients.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                
                if viewModel.todaysMeals.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    mealListView
                }
            }
        }
        .sheet(isPresented: $showingAddMeal) {
            AddMealView { mealEntry in
                viewModel.addMealEntry(mealEntry)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.md) {
            Text("My Diet")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .accentColor(AppColors.accentYellow)
                .colorScheme(.dark)
                .padding(.horizontal, AppSpacing.md)
            
            if !viewModel.todaysMeals.isEmpty {
                dailySummaryCard
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.sm)
    }
    
    private var dailySummaryCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("Today's Summary")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(viewModel.totalCaloriesToday) calories consumed")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: AppSpacing.xs) {
                Text("\(viewModel.todaysMeals.count)")
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.accentText)
                
                Text("meals")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
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
    
    private var mealListView: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(viewModel.todaysMeals) { mealEntry in
                    MealEntryCard(
                        mealEntry: mealEntry,
                        onStatusChange: { newStatus in
                            viewModel.updateMealStatus(mealEntry.id, status: newStatus)
                        },
                        onDelete: {
                            viewModel.removeMealEntry(mealEntry.id)
                        }
                    )
                }
                
                Button(action: {
                    showingAddMeal = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Meal")
                    }
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.large)
                            .fill(AppColors.accentYellow)
                    )
                }
                .padding(.top, AppSpacing.md)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, 120)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: AppSpacing.sm) {
                Text("Diet is empty")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Start planning your meals for today")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                showingAddMeal = true
            } label: {
                Text("Add Meal")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.medium)
                            .fill(AppColors.accentYellow)
                    )
            }
            
            Spacer()
        }
        .padding(.vertical, AppSpacing.xxl)
    }
}

struct MealEntryCard: View {
    let mealEntry: MealEntry
    let onStatusChange: (MealStatus) -> Void
    let onDelete: () -> Void
    
    @State private var showingStatusPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(mealEntry.food.name)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    HStack {
                        Text(mealEntry.food.type.rawValue)
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("•")
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("\(mealEntry.food.calories) cal")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("•")
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(mealEntry.food.goal.rawValue)
                            .font(AppFonts.caption)
                            .foregroundColor(goalColor(for: mealEntry.food.goal))
                    }
                }
                
                Spacer()
                
                Menu {
                    ForEach(MealStatus.allCases, id: \.self) { status in
                        Button(status.rawValue) {
                            onStatusChange(status)
                        }
                    }
                    
                    Divider()
                    
                    Button("Delete", role: .destructive) {
                        onDelete()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            HStack {
                statusIndicator
                
                Spacer()
                
                if let plannedTime = mealEntry.plannedTime {
                    Text("Planned: \(plannedTime, formatter: timeFormatter)")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.large)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.large)
                        .stroke(statusBorderColor, lineWidth: 2)
                )
        )
    }
    
    private var statusIndicator: some View {
        HStack(spacing: AppSpacing.xs) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            Text(mealEntry.status.rawValue)
                .font(AppFonts.caption)
                .foregroundColor(statusColor)
        }
    }
    
    private var statusColor: Color {
        switch mealEntry.status {
        case .planned: return AppColors.accentYellow
        case .consumed: return AppColors.success
        case .skipped: return AppColors.error
        }
    }
    
    private var statusBorderColor: Color {
        switch mealEntry.status {
        case .planned: return AppColors.cardBorder
        case .consumed: return AppColors.success.opacity(0.3)
        case .skipped: return AppColors.error.opacity(0.3)
        }
    }
    
    private func goalColor(for goal: MoodGoal) -> Color {
        switch goal {
        case .energy: return AppColors.energyColor
        case .focus: return Color.green
        case .relax: return AppColors.relaxColor
        }
    }
}

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    MealPlanView()
        .environmentObject(MealPlanViewModel())
}
