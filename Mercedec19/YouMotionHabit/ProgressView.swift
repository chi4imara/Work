import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var progressVM: ProgressViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()

            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Progress & Results")
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            Text("Track your fitness journey and achievements")
                                .font(.ubuntu(14, weight: .regular))
                                .foregroundColor(ColorTheme.textSecondary)
                        }
                        
                        Spacer()
                    }
                    
                    HStack(spacing: 0) {
                        ForEach(["Overview", "Charts", "Achievements"], id: \.self) { tab in
                            let index = ["Overview", "Charts", "Achievements"].firstIndex(of: tab) ?? 0
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = index
                                }
                            } label: {
                                Text(tab)
                                    .font(.ubuntu(14, weight: selectedTab == index ? .bold : .medium))
                                    .foregroundColor(selectedTab == index ? ColorTheme.primaryBlue : ColorTheme.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(selectedTab == index ? ColorTheme.primaryYellow : Color.clear)
                                    )
                            }
                        }
                    }
                    .padding(4)
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        switch selectedTab {
                        case 0:
                            OverviewTab()
                        case 1:
                            ChartsTab()
                        case 2:
                            AchievementsTab()
                        default:
                            OverviewTab()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .environmentObject(progressVM)
    }
}

struct OverviewTab: View {
    @EnvironmentObject var progressVM: ProgressViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCard(
                    title: "Total Workouts",
                    value: "\(progressVM.progressData.totalWorkouts)",
                    icon: "dumbbell.fill",
                    color: ColorTheme.accentGreen
                )
                
                StatCard(
                    title: "Current Streak",
                    value: "\(progressVM.progressData.currentStreak)",
                    icon: "flame.fill",
                    color: ColorTheme.accentOrange
                )
                
                StatCard(
                    title: "Longest Streak",
                    value: "\(progressVM.progressData.longestStreak)",
                    icon: "trophy.fill",
                    color: ColorTheme.primaryYellow
                )
                
                StatCard(
                    title: "This Week",
                    value: "\(progressVM.getWeeklyProgress().reduce(0, +))",
                    icon: "calendar.badge.checkmark",
                    color: ColorTheme.accentPurple
                )
            }
            
            WeeklyProgressCard()
            
            EnergyLevelCard()
            
            RecentAchievementsCard()
        }
    }
}

struct ChartsTab: View {
    @EnvironmentObject var progressVM: ProgressViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            ChartCard(title: "Weekly Activity") {
                WeeklyChart(data: progressVM.getWeeklyProgress())
            }
            
            ChartCard(title: "Monthly Overview") {
                MonthlyChart()
            }
            
            ChartCard(title: "Energy Levels") {
                EnergyChart()
            }
        }
    }
}

struct AchievementsTab: View {
    @EnvironmentObject var progressVM: ProgressViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(progressVM.progressData.achievements) { achievement in
                AchievementCard(achievement: achievement)
            }
            
            if progressVM.progressData.achievements.allSatisfy({ !$0.isUnlocked }) {
                EmptyAchievementsView()
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct WeeklyProgressCard: View {
    @EnvironmentObject var progressVM: ProgressViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week's Activity")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            WeeklyChart(data: progressVM.getWeeklyProgress())
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct WeeklyChart: View {
    let data: [Int]
    private let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(0..<7, id: \.self) { index in
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(data[index] > 0 ? ColorTheme.primaryYellow : ColorTheme.cardBackground)
                        .frame(width: 30, height: max(4, CGFloat(data[index]) * 20 + 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(ColorTheme.cardBorder, lineWidth: 1)
                        )
                    
                    Text(days[index])
                        .font(.ubuntu(10, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct EnergyLevelCard: View {
    @EnvironmentObject var progressVM: ProgressViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Energy Level")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            HStack {
                Text("How are you feeling today?")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { level in
                    Button(action: {
                        progressVM.selectedEnergyLevel = level
                        progressVM.recordEnergyLevel(level)
                    }) {
                        Image(systemName: level <= progressVM.selectedEnergyLevel ? "star.fill" : "star")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(level <= progressVM.selectedEnergyLevel ? ColorTheme.primaryYellow : ColorTheme.textSecondary)
                    }
                }
                
                Spacer()
                
                Text("\(progressVM.selectedEnergyLevel)/5")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct RecentAchievementsCard: View {
    @EnvironmentObject var progressVM: ProgressViewModel
    
    var recentAchievements: [Achievement] {
        progressVM.progressData.achievements
            .filter { $0.isUnlocked }
            .sorted { ($0.unlockedDate ?? Date.distantPast) > ($1.unlockedDate ?? Date.distantPast) }
            .prefix(3)
            .map { $0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Achievements")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Spacer()
                
                if !recentAchievements.isEmpty {
                    Text("View All")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(ColorTheme.primaryYellow)
                }
            }
            
            if recentAchievements.isEmpty {
                VStack(spacing: 8) {
                    Text("No achievements yet")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    Text("Complete workouts to unlock achievements")
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                VStack(spacing: 8) {
                    ForEach(recentAchievements) { achievement in
                        HStack(spacing: 12) {
                            Image(systemName: achievement.iconName)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(ColorTheme.primaryYellow)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(achievement.title)
                                    .font(.ubuntu(14, weight: .bold))
                                    .foregroundColor(ColorTheme.textPrimary)
                                
                                Text(achievement.description)
                                    .font(.ubuntu(12, weight: .regular))
                                    .foregroundColor(ColorTheme.textSecondary)
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct ChartCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct MonthlyChart: View {
    var body: some View {
        VStack {
            Text("Monthly data visualization would go here")
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(ColorTheme.textSecondary)
                .frame(height: 100)
        }
    }
}

struct EnergyChart: View {
    var body: some View {
        VStack {
            Text("Energy levels chart would go here")
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(ColorTheme.textSecondary)
                .frame(height: 100)
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? ColorTheme.primaryYellow.opacity(0.2) : ColorTheme.cardBackground)
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.iconName)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(achievement.isUnlocked ? ColorTheme.primaryYellow : ColorTheme.textSecondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(achievement.isUnlocked ? ColorTheme.textPrimary : ColorTheme.textSecondary)
                
                Text(achievement.description)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                
                if achievement.isUnlocked, let date = achievement.unlockedDate {
                    Text("Unlocked \(date.formatted(date: .abbreviated, time: .omitted))")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(ColorTheme.primaryYellow)
                }
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(ColorTheme.successGreen)
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
}

struct EmptyAchievementsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "trophy")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(ColorTheme.textSecondary)
            
            VStack(spacing: 8) {
                Text("No achievements yet")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("Complete workouts to unlock your first achievement")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
    }
}
