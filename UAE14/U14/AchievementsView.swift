import SwiftUI

struct AchievementsView: View {
    @ObservedObject var viewModel: PullUpViewModel
    @State private var showingResetAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        overallStatsView
                        
                        achievementsGrid
                        
                        recentMilestonesView
                        
                        resetDataSection
                    }
                    .padding(.bottom, 120)
                }
            }
            .padding(.horizontal, 20)
        }
        .alert("Reset All Data", isPresented: $showingResetAlert) {
            Button("Delete", role: .destructive) {
                viewModel.clearAllData()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete all data? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Achievements")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
    
    private var overallStatsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Statistics")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            let stats = viewModel.overallStatistics
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCard(
                    title: "Total Days",
                    value: "\(stats.totalEntries)",
                    icon: "calendar",
                    color: AppColors.lightBlue
                )
                
                StatCard(
                    title: "Total Pull-ups",
                    value: "\(stats.totalPullUps)",
                    icon: "sum",
                    color: AppColors.orange
                )
                
                StatCard(
                    title: "Average",
                    value: String(format: "%.1f", stats.averagePerDay),
                    icon: "chart.bar.fill",
                    color: AppColors.lightBlue
                )
                
                StatCard(
                    title: "Personal Best",
                    value: "\(stats.maxInOneDay)",
                    icon: "trophy.fill",
                    color: AppColors.orange
                )
            }
        }
    }
    
    private var achievementsGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(currentAchievements) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
        }
    }
    
    private var currentAchievements: [Achievement] {
        let stats = viewModel.overallStatistics
        return calculateAchievements(stats: stats)
    }
    
    private var recentMilestonesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Milestones")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            if currentMilestones.isEmpty {
                Text("Keep training to unlock milestones!")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
                    .cardStyle()
            } else {
                VStack(spacing: 12) {
                    ForEach(currentMilestones.prefix(5)) { milestone in
                        MilestoneRow(milestone: milestone)
                    }
                }
            }
        }
    }
    
    private var currentMilestones: [Milestone] {
        return calculateMilestones()
    }
    
    private var resetDataSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Data Management")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Reset All Data")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("This will permanently delete all your workout entries")
                            .font(.ubuntu(14))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                }
                
                Button("Reset Data") {
                    showingResetAlert = true
                }
                .buttonStyle(DangerButtonStyle())
                .frame(maxWidth: .infinity)
            }
            .padding(20)
            .cardStyle()
        }
    }
    
    private func calculateAchievements(stats: Statistics) -> [Achievement] {
        var achievements: [Achievement] = []
        
        if stats.totalPullUps >= 100 {
            achievements.append(Achievement(
                id: "100_total",
                title: "Century Club",
                description: "Complete 100 pull-ups",
                icon: "gauge.with.dots.needle.bottom.100percent",
                isUnlocked: true,
                progress: 1.0
            ))
        } else {
            achievements.append(Achievement(
                id: "100_total",
                title: "Century Club",
                description: "Complete 100 pull-ups",
                icon: "gauge.with.dots.needle.bottom.100percent",
                isUnlocked: false,
                progress: min(Double(stats.totalPullUps) / 100.0, 1.0)
            ))
        }
        
        if stats.totalPullUps >= 500 {
            achievements.append(Achievement(
                id: "500_total",
                title: "Half Grand",
                description: "Complete 500 pull-ups",
                icon: "gauge.with.dots.needle.100percent",
                isUnlocked: true,
                progress: 1.0
            ))
        } else {
            achievements.append(Achievement(
                id: "500_total",
                title: "Half Grand",
                description: "Complete 500 pull-ups",
                icon: "gauge.with.dots.needle.100percent",
                isUnlocked: false,
                progress: min(Double(stats.totalPullUps) / 500.0, 1.0)
            ))
        }
        
        if stats.totalEntries >= 7 {
            achievements.append(Achievement(
                id: "week_streak",
                title: "Week Warrior",
                description: "Train for 7 days",
                icon: "calendar.badge.clock",
                isUnlocked: true,
                progress: 1.0
            ))
        } else {
            achievements.append(Achievement(
                id: "week_streak",
                title: "Week Warrior",
                description: "Train for 7 days",
                icon: "calendar.badge.clock",
                isUnlocked: false,
                progress: min(Double(stats.totalEntries) / 7.0, 1.0)
            ))
        }
        
        if stats.totalEntries >= 30 {
            achievements.append(Achievement(
                id: "month_streak",
                title: "Monthly Master",
                description: "Train for 30 days",
                icon: "calendar.badge.checkmark",
                isUnlocked: true,
                progress: 1.0
            ))
        } else {
            achievements.append(Achievement(
                id: "month_streak",
                title: "Monthly Master",
                description: "Train for 30 days",
                icon: "calendar.badge.checkmark",
                isUnlocked: false,
                progress: min(Double(stats.totalEntries) / 30.0, 1.0)
            ))
        }
        
        if stats.maxInOneDay >= 20 {
            achievements.append(Achievement(
                id: "20_single",
                title: "Power Player",
                description: "Do 20+ pull-ups in one day",
                icon: "bolt.fill",
                isUnlocked: true,
                progress: 1.0
            ))
        } else {
            achievements.append(Achievement(
                id: "20_single",
                title: "Power Player",
                description: "Do 20+ pull-ups in one day",
                icon: "bolt.fill",
                isUnlocked: false,
                progress: min(Double(stats.maxInOneDay) / 20.0, 1.0)
            ))
        }
        
        if stats.maxInOneDay >= 50 {
            achievements.append(Achievement(
                id: "50_single",
                title: "Elite Athlete",
                description: "Do 50+ pull-ups in one day",
                icon: "crown.fill",
                isUnlocked: true,
                progress: 1.0
            ))
        } else {
            achievements.append(Achievement(
                id: "50_single",
                title: "Elite Athlete",
                description: "Do 50+ pull-ups in one day",
                icon: "crown.fill",
                isUnlocked: false,
                progress: min(Double(stats.maxInOneDay) / 50.0, 1.0)
            ))
        }
        
        return achievements
    }
    
    private func calculateMilestones() -> [Milestone] {
        let entries = viewModel.entries.sorted { $0.date > $1.date }
        var milestones: [Milestone] = []
        
        var totalPullUps = 0
        for entry in entries.reversed() {
            totalPullUps += entry.count
            
            if totalPullUps >= 100 && milestones.filter({ $0.type == .totalPullUps && $0.value == 100 }).isEmpty {
                milestones.append(Milestone(
                    id: UUID(),
                    type: .totalPullUps,
                    value: 100,
                    date: entry.date,
                    description: "Reached 100 total pull-ups"
                ))
            }
            
            if totalPullUps >= 500 && milestones.filter({ $0.type == .totalPullUps && $0.value == 500 }).isEmpty {
                milestones.append(Milestone(
                    id: UUID(),
                    type: .totalPullUps,
                    value: 500,
                    date: entry.date,
                    description: "Reached 500 total pull-ups"
                ))
            }
            
            if entry.count >= 20 && milestones.filter({ $0.type == .singleDay && $0.value == 20 }).isEmpty {
                milestones.append(Milestone(
                    id: UUID(),
                    type: .singleDay,
                    value: 20,
                    date: entry.date,
                    description: "Did 20 pull-ups in one day"
                ))
            }
        }
        
        return milestones.sorted { $0.date > $1.date }
    }
}

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
    let progress: Double
}

struct Milestone: Identifiable {
    let id: UUID
    let type: MilestoneType
    let value: Int
    let date: Date
    let description: String
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

enum MilestoneType {
    case totalPullUps
    case singleDay
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? AppColors.orange.opacity(0.2) : AppColors.cardBackground)
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 28))
                    .foregroundColor(achievement.isUnlocked ? AppColors.orange : AppColors.secondaryText)
            }
            
            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(achievement.isUnlocked ? AppColors.primaryText : AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                
                Text(achievement.description)
                    .font(.ubuntu(11))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                if !achievement.isUnlocked {
                    ProgressView(value: achievement.progress)
                        .tint(AppColors.lightBlue)
                        .frame(height: 4)
                }
            }
        }
        .padding(16)
        .cardStyle()
        .opacity(achievement.isUnlocked ? 1.0 : 0.7)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(16)
        .cardStyle()
    }
}

struct MilestoneRow: View {
    let milestone: Milestone
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "star.fill")
                .font(.system(size: 20))
                .foregroundColor(AppColors.orange)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(milestone.description)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text(milestone.dateString)
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Text("\(milestone.value)")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.lightBlue)
        }
        .padding(16)
        .cardStyle()
    }
}

#Preview {
    AchievementsView(viewModel: PullUpViewModel())
}
