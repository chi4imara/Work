import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Statistics")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    StatisticsOverviewSection(viewModel: viewModel)
                    
                    HabitsStatisticsSection(habits: viewModel.habits)
                    
                    ActivityStatisticsSection(dailyProgress: viewModel.dailyProgress)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
    }
}

struct StatisticsOverviewSection: View {
    @ObservedObject var viewModel: AppViewModel
    
    private var totalDaysTracked: Int {
        viewModel.dailyProgress.count
    }
    
    private var currentStreak: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        for i in 0..<365 {
            let date = calendar.startOfDay(for: today.addingTimeInterval(-Double(i) * 24 * 60 * 60))
            if let progress = viewModel.dailyProgress.first(where: { calendar.isDate($0.date, inSameDayAs: date) }),
               progress.completionPercentage > 0 {
                streak += 1
            } else {
                break
            }
        }
        return streak
    }
    
    private var averageCompletion: Double {
        guard !viewModel.dailyProgress.isEmpty else { return 0 }
        let total = viewModel.dailyProgress.reduce(0) { $0 + $1.completionPercentage }
        return total / Double(viewModel.dailyProgress.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCardView(
                    title: "Days Tracked",
                    value: "\(totalDaysTracked)",
                    icon: "calendar"
                )
                
                StatCardView(
                    title: "Current Streak",
                    value: "\(currentStreak)",
                    icon: "flame.fill"
                )
                
                StatCardView(
                    title: "Completion Rate",
                    value: "\(Int(averageCompletion * 100))%",
                    icon: "chart.line.uptrend.xyaxis"
                )
                
                StatCardView(
                    title: "Active Habits",
                    value: "\(viewModel.activeHabits.count)",
                    icon: "list.bullet"
                )
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(20)
    }
}

struct HabitsStatisticsSection: View {
    let habits: [Habit]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Habits Progress")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            if habits.isEmpty {
                Text("No habits yet. Add habits to see statistics.")
                    .font(.ubuntu(14, weight: .light))
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else {
                VStack(spacing: 12) {
                    ForEach(habits) { habit in
                        HStack {
                            Image(systemName: habit.category.iconName)
                                .font(.system(size: 20))
                                .foregroundColor(AppColors.primaryText)
                                .frame(width: 36)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(habit.name)
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("\(habit.currentStreak) day streak")
                                    .font(.ubuntu(12, weight: .light))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            
                            Spacer()
                            
                            Text("\(habit.completedDates.count) total")
                                .font(.ubuntu(12, weight: .light))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(16)
                        .background(AppColors.softGradient)
                        .cornerRadius(12)
                    }
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(20)
    }
}

struct ActivityStatisticsSection: View {
    let dailyProgress: [DailyProgress]
    
    private var meditationDays: Int {
        dailyProgress.filter { $0.meditationCompleted }.count
    }
    
    private var challengeDays: Int {
        dailyProgress.filter { !$0.completedChallenges.isEmpty }.count
    }
    
    private var moodDays: Int {
        dailyProgress.filter { !$0.selectedMoods.isEmpty }.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCardView(
                    title: "Meditation Days",
                    value: "\(meditationDays)",
                    icon: "leaf.fill"
                )
                
                StatCardView(
                    title: "Challenge Days",
                    value: "\(challengeDays)",
                    icon: "target"
                )
                
                StatCardView(
                    title: "Mood Logged",
                    value: "\(moodDays)",
                    icon: "heart.fill"
                )
                
                StatCardView(
                    title: "Total Activities",
                    value: "\(dailyProgress.reduce(0) { $0 + ($1.completedHabits.count) })",
                    icon: "checkmark.circle.fill"
                )
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(20)
    }
}

#Preview {
    StatisticsView(viewModel: AppViewModel())
}
