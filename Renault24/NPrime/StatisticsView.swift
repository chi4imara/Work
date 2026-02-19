import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var appState: AppState
    
    private var calendar: Calendar { Calendar.current }
    private var startOfWeek: Date {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
    }
    
    private var workoutsThisWeek: [Workout] {
        appState.workouts.filter { $0.date >= startOfWeek && $0.isCompleted }
    }
    
    private var mealsThisWeek: [Meal] {
        appState.meals.filter { $0.date >= startOfWeek }
    }
    
    private var totalCaloriesThisWeek: Int {
        mealsThisWeek.reduce(0) { $0 + $1.calories }
    }
    
    private var challengesCompletedThisWeek: Int {
        appState.dailyChallenges.filter { $0.date >= startOfWeek && $0.isCompleted }.count
    }
    
    private var averageGoalProgress: Double {
        guard !appState.goals.isEmpty else { return 0 }
        return appState.goals.map { $0.currentValue / $0.targetValue }.reduce(0, +) / Double(appState.goals.count)
    }
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        headerSection
                        
                        statsGrid
                        
                        weeklyOverview
                        
                        goalsOverview
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your progress at a glance")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            StatCardView(
                title: "Workouts",
                value: "\(workoutsThisWeek.count)",
                subtitle: "This week",
                icon: "dumbbell",
                color: AppColors.secondary
            )
            
            StatCardView(
                title: "Calories",
                value: "\(totalCaloriesThisWeek)",
                subtitle: "This week",
                icon: "flame.fill",
                color: AppColors.accent
            )
            
            StatCardView(
                title: "Challenges",
                value: "\(challengesCompletedThisWeek)",
                subtitle: "Completed",
                icon: "star.fill",
                color: AppColors.warning
            )
            
            StatCardView(
                title: "Goals",
                value: "\(Int(averageGoalProgress * 100))%",
                subtitle: "Avg. progress",
                icon: "target",
                color: AppColors.success
            )
        }
    }
    
    private var weeklyOverview: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accent)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(AppColors.accent.opacity(0.15)))
                
                Text("This Week")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.text)
            }
            
            VStack(spacing: 12) {
                StatRowView(
                    label: "Workouts completed",
                    value: "\(workoutsThisWeek.count)",
                    progress: nil
                )
                
                StatRowView(
                    label: "Meals logged",
                    value: "\(mealsThisWeek.count)",
                    progress: nil
                )
                
                StatRowView(
                    label: "Total calories",
                    value: "\(totalCaloriesThisWeek) cal",
                    progress: nil
                )
                
                StatRowView(
                    label: "Challenges done",
                    value: "\(challengesCompletedThisWeek)",
                    progress: nil
                )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground.opacity(0.5))
            )
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(AppColors.accent.opacity(0.15), lineWidth: 1)
                )
        )
    }
    
    private var goalsOverview: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "target")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.success)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(AppColors.success.opacity(0.15)))
                
                Text("Goals Progress")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.text)
            }
            
            if appState.goals.isEmpty {
                Text("No goals set yet")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else {
                VStack(spacing: 12) {
                    ForEach(appState.goals.prefix(5)) { goal in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(goal.title)
                                    .font(.ubuntu(15, weight: .medium))
                                    .foregroundColor(AppColors.text)
                                Text("\(Int(goal.currentValue))/\(Int(goal.targetValue)) \(goal.unit)")
                                    .font(.ubuntu(12, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            Spacer()
                            CircularProgressView(
                                progress: goal.currentValue / goal.targetValue,
                                size: 36,
                                lineWidth: 4
                            )
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppColors.cardBackground.opacity(0.4))
                        )
                    }
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(AppColors.accent.opacity(0.15), lineWidth: 1)
                )
        )
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(value)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.text)
            
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(AppColors.text)
            
            Text(subtitle)
                .font(.ubuntu(11, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct StatRowView: View {
    let label: String
    let value: String
    let progress: Double?
    
    var body: some View {
        HStack {
            Text(label)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(AppColors.text)
            
            Spacer()
            
            Text(value)
                .font(.ubuntu(14, weight: .bold))
                .foregroundColor(AppColors.accent)
            
            if let progress = progress {
                CircularProgressView(progress: progress, size: 28, lineWidth: 3)
            }
        }
    }
}

#Preview {
    StatisticsView()
        .environmentObject(AppState())
}
