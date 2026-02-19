import SwiftUI

struct StatisticsView: View {
    @ObservedObject var historyViewModel: HistoryViewModel
    @ObservedObject var habitsViewModel: HabitsViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerView
                    
                    overviewCards
                    
                    habitsStatsSection
                    
                    weeklyTrendSection
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.sm)
                .padding(.bottom, 120)
            }
        }
        .onAppear {
            historyViewModel.refresh()
            habitsViewModel.refresh()
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Statistics")
                    .font(AppFonts.title2())
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Your progress at a glance")
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 28))
                .foregroundColor(AppColors.iconAccent)
        }
        .padding(.horizontal, AppSpacing.sm)
    }
    
    private var overviewCards: some View {
        VStack(spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.md) {
                StatOverviewCard(
                    title: "Current Streak",
                    value: "\(historyViewModel.getStreakCount())",
                    unit: "days",
                    icon: "flame",
                    color: AppColors.iconAccent
                )
                
                StatOverviewCard(
                    title: "Active Habits",
                    value: "\(habitsViewModel.habits.filter { $0.isActive }.count)",
                    unit: "total",
                    icon: "star",
                    color: AppColors.lightGreen
                )
            }
            
            HStack(spacing: AppSpacing.md) {
                StatOverviewCard(
                    title: "This Week",
                    value: "\(getWeeklyCompletedDays())",
                    unit: "/ 7 days",
                    icon: "calendar",
                    color: AppColors.lightBlue
                )
                
                StatOverviewCard(
                    title: "Completion",
                    value: "\(Int(getAverageCompletion() * 100))",
                    unit: "% avg",
                    icon: "percent",
                    color: AppColors.softPink
                )
            }
        }
    }
    
    private var habitsStatsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Habits Overview")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.sm)
            
            VStack(spacing: AppSpacing.sm) {
                ForEach(habitsViewModel.habits.prefix(5)) { habit in
                    HabitStatRowView(habit: habit)
                }
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
    
    private var weeklyTrendSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Last 7 Days")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.sm)
            
            HStack(alignment: .bottom, spacing: AppSpacing.xs) {
                ForEach(getLastSevenDays(), id: \.self) { date in
                    VStack(spacing: AppSpacing.xs) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                historyViewModel.getCompletionPercentageForDate(date) > 0.5
                                    ? AppColors.iconAccent
                                    : AppColors.cardBorder
                            )
                            .frame(height: max(20, CGFloat(historyViewModel.getCompletionPercentageForDate(date)) * 80))
                        
                        Text(date.formatted(.dateTime.weekday(.abbreviated)))
                            .font(AppFonts.caption2())
                            .foregroundColor(AppColors.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 120)
            .padding(AppSpacing.md)
            .background(AppColors.cardBackground)
            .cornerRadius(AppCornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
        }
    }
    
    private func getWeeklyCompletedDays() -> Int {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        var count = 0
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                if historyViewModel.getCompletionPercentageForDate(date) > 0.5 {
                    count += 1
                }
            }
        }
        return count
    }
    
    private func getAverageCompletion() -> Double {
        let calendar = Calendar.current
        var total: Double = 0
        var count = 0
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                total += historyViewModel.getCompletionPercentageForDate(date)
                count += 1
            }
        }
        return count > 0 ? total / Double(count) : 0
    }
    
    private func getLastSevenDays() -> [Date] {
        let calendar = Calendar.current
        return (0..<7).compactMap { i in
            calendar.date(byAdding: .day, value: -i, to: Date())
        }.reversed()
    }
}

struct StatOverviewCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.iconPrimary)
                
                Spacer()
            }
            
            Text(value)
                .font(AppFonts.title2())
                .foregroundColor(AppColors.textPrimary)
            
            HStack {
                Text(unit)
                    .font(AppFonts.caption2())
                    .foregroundColor(AppColors.textTertiary)
                
                Spacer()
            }
            
            Text(title)
                .font(AppFonts.caption())
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .stroke(color.opacity(0.5), lineWidth: 1)
        )
    }
}

struct HabitStatRowView: View {
    let habit: Habit
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(habit.category.color.opacity(0.2))
                    .frame(width: 36, height: 36)
                
                Image(systemName: habit.icon)
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.iconPrimary)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.name)
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.textPrimary)
                
                Text(habit.category.rawValue)
                    .font(AppFonts.caption2())
                    .foregroundColor(AppColors.textTertiary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(habit.currentStreak)")
                    .font(AppFonts.headline())
                    .foregroundColor(AppColors.iconAccent)
                
                Text("day streak")
                    .font(AppFonts.caption2())
                    .foregroundColor(AppColors.textTertiary)
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }
}

#Preview {
    StatisticsView(historyViewModel: HistoryViewModel(), habitsViewModel: HabitsViewModel())
}
