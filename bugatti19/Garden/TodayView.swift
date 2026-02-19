import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: TodayViewModel
    @ObservedObject var historyViewModel: HistoryViewModel
    
    @State private var showingSleepEntry = false
    @State private var showingMealEntry = false
    @State private var showingActivityEntry = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerView
                    
                    progressIndicator
                    
                    sleepBlock
                    
                    nutritionBlock
                    
                    activityBlock
                    
                    dailyChallengeBlock
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.sm)
                .padding(.bottom, 120)
            }
        }
        .onAppear {
            viewModel.updateGreeting()
            syncTodayToHistory()
        }
        .sheet(isPresented: $showingSleepEntry) {
            SleepEntryView { bedtime, wakeTime, quality in
                viewModel.addSleepEntry(bedtime: bedtime, wakeTime: wakeTime, quality: quality)
                syncTodayToHistory()
            }
        }
        .sheet(isPresented: $showingMealEntry) {
            MealEntryView { type, name, rating in
                viewModel.addMealEntry(type: type, name: name, healthRating: rating)
                syncTodayToHistory()
            }
        }
        .sheet(isPresented: $showingActivityEntry) {
            ActivityEntryView { type, name, duration in
                viewModel.addActivityEntry(type: type, name: name, duration: duration)
                syncTodayToHistory()
            }
        }
    }
    
    private func syncTodayToHistory() {
        historyViewModel.addOrUpdateProgress(viewModel.todayProgress)
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.greeting)
                        .font(AppFonts.title2())
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("How are you feeling today?")
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Text(Date().formatted(.dateTime.weekday(.wide).month().day()))
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.textTertiary)
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, AppSpacing.xs)
                    .background(AppColors.cardBackground)
                    .cornerRadius(AppCornerRadius.sm)
            }
        }
        .padding(.horizontal, AppSpacing.sm)
    }
    
    private var progressIndicator: some View {
        VStack(spacing: AppSpacing.sm) {
            HStack {
                Text("Today's Progress")
                    .font(AppFonts.headline())
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Text("\(Int(viewModel.todayProgress.completionPercentage * 100))%")
                    .font(AppFonts.headline())
                    .foregroundColor(AppColors.iconAccent)
            }
            
            ProgressView(value: viewModel.todayProgress.completionPercentage)
                .progressViewStyle(CustomProgressViewStyle())
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
    
    private var sleepBlock: some View {
        ActionBlock(
            title: "Sleep",
            subtitle: viewModel.todayProgress.sleepEntry != nil ? 
                "\(String(format: "%.1f", viewModel.todayProgress.sleepEntry?.durationHours ?? 0)) hours" : 
                "Track your sleep",
            icon: "bed.double",
            isCompleted: viewModel.todayProgress.sleepEntry != nil,
            supportText: "Good sleep is your first step to energy"
        ) {
            showingSleepEntry = true
        }
    }
    
    private var nutritionBlock: some View {
        VStack(spacing: AppSpacing.sm) {
            ActionBlock(
                title: "Nutrition",
                subtitle: viewModel.todayProgress.mealEntries.isEmpty ? 
                    "Add your meals" : 
                    "\(viewModel.todayProgress.mealEntries.count) meals logged",
                icon: "leaf",
                isCompleted: !viewModel.todayProgress.mealEntries.isEmpty,
                supportText: viewModel.todayProgress.mealEntries.isEmpty ? 
                    "Fuel your body with good choices" : 
                    "Great job staying mindful!"
            ) {
                showingMealEntry = true
            }
            
            if !viewModel.todayProgress.mealEntries.isEmpty {
                LazyVStack(spacing: AppSpacing.xs) {
                    ForEach(viewModel.todayProgress.mealEntries.suffix(3)) { meal in
                        MealRowView(meal: meal)
                    }
                }
                .padding(.horizontal, AppSpacing.sm)
            }
        }
    }
    
    private var activityBlock: some View {
        VStack(spacing: AppSpacing.sm) {
            ActionBlock(
                title: "Physical Activity",
                subtitle: viewModel.todayProgress.activityEntries.isEmpty ? 
                    "Add your activities" : 
                    "\(viewModel.todayProgress.activityEntries.count) activities",
                icon: "figure.run",
                isCompleted: !viewModel.todayProgress.activityEntries.isEmpty,
                supportText: "Movement brings energy and joy"
            ) {
                showingActivityEntry = true
            }
            
            if !viewModel.todayProgress.activityEntries.isEmpty {
                LazyVStack(spacing: AppSpacing.xs) {
                    ForEach(viewModel.todayProgress.activityEntries) { activity in
                        ActivityRowView(activity: activity) {
                            viewModel.completeActivity(id: activity.id)
                            syncTodayToHistory()
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.sm)
            }
        }
    }
    
    private var dailyChallengeBlock: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mini-Challenge of the Day")
                        .font(AppFonts.headline())
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(viewModel.dailyChallenge.title)
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: viewModel.dailyChallenge.category.icon)
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.iconAccent)
            }
            
            Text(viewModel.dailyChallenge.description)
                .font(AppFonts.callout())
                .foregroundColor(AppColors.textTertiary)
            
            Button(action: {
                withAnimation(.spring()) {
                    viewModel.completeDailyChallenge()
                    syncTodayToHistory()
                }
            }) {
                HStack {
                    Image(systemName: viewModel.dailyChallenge.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(viewModel.dailyChallenge.isCompleted ? AppColors.lightGreen : AppColors.iconAccent)
                    
                    Text(viewModel.dailyChallenge.isCompleted ? "Completed!" : "I did it!")
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.textPrimary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    viewModel.dailyChallenge.isCompleted ? 
                    AppColors.lightGreen.opacity(0.2) : 
                    AppColors.primaryYellow.opacity(0.2)
                )
                .cornerRadius(AppCornerRadius.sm)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.sm)
                        .stroke(
                            viewModel.dailyChallenge.isCompleted ? 
                            AppColors.lightGreen : 
                            AppColors.primaryYellow, 
                            lineWidth: 1
                        )
                )
            }
            .disabled(viewModel.dailyChallenge.isCompleted)
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct ActionBlock: View {
    let title: String
    let subtitle: String
    let icon: String
    let isCompleted: Bool
    let supportText: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.iconAccent)
                        .frame(width: 32)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(AppFonts.headline())
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(subtitle)
                            .font(AppFonts.callout())
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                Spacer()
                
                Button(action: action) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "plus.circle")
                        .font(.system(size: 24))
                        .foregroundColor(isCompleted ? AppColors.lightGreen : AppColors.iconAccent)
                }
            }
            
            Text(supportText)
                .font(AppFonts.caption())
                .foregroundColor(AppColors.textTertiary)
                .italic()
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct MealRowView: View {
    let meal: MealEntry
    
    var body: some View {
        HStack {
            Image(systemName: meal.type.icon)
                .foregroundColor(AppColors.iconAccent)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(meal.name)
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.textPrimary)
                
                Text(meal.type.rawValue)
                    .font(AppFonts.caption2())
                    .foregroundColor(AppColors.textTertiary)
            }
            
            Spacer()
            
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(index <= meal.healthRating ? AppColors.iconAccent : AppColors.textTertiary.opacity(0.3))
                }
            }
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .background(AppColors.cardBackground.opacity(0.5))
        .cornerRadius(AppCornerRadius.sm)
    }
}

struct ActivityRowView: View {
    let activity: ActivityEntry
    let onComplete: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: activity.type.icon)
                .foregroundColor(AppColors.iconAccent)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.name)
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.textPrimary)
                
                if activity.duration > 0 {
                    Text("\(Int(activity.duration / 60)) min")
                        .font(AppFonts.caption2())
                        .foregroundColor(AppColors.textTertiary)
                }
            }
            
            Spacer()
            
            Button(action: onComplete) {
                Image(systemName: activity.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(activity.isCompleted ? AppColors.lightGreen : AppColors.iconAccent)
            }
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .background(AppColors.cardBackground.opacity(0.5))
        .cornerRadius(AppCornerRadius.sm)
    }
}

struct CustomProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            let fraction = configuration.fractionCompleted ?? 0
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.primaryWhite.opacity(0.2))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [AppColors.iconAccent, AppColors.softYellow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(0, min(fraction * geometry.size.width, geometry.size.width)), height: 8)
                    .animation(.easeInOut(duration: 0.5), value: fraction)
            }
        }
        .frame(height: 8)
    }
}

#Preview {
    TodayView(viewModel: TodayViewModel(), historyViewModel: HistoryViewModel())
}
