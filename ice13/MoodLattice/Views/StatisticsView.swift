import SwiftUI

struct StatisticsView: View {
    @ObservedObject var dataManager: MoodDataManager
    @State private var selectedDate = Date()
    
    private var statistics: MoodStatistics {
        dataManager.calculateStatistics(for: selectedDate)
    }
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            if dataManager.entries.isEmpty {
                emptyStateView
            } else {
                statisticsContentView
            }
        }
    }
    
    private var statisticsContentView: some View {
        ScrollView {
            VStack(spacing: 25) {
                headerView
                
                mainStatsView
                
                monthlyDistributionView
                
                weeklyPatternsView
                
                monthlySummaryView
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 15) {
            Text("Statistics")
                .font(FontManager.ubuntu(size: 28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Overview of your mood patterns and habits")
                .font(FontManager.ubuntu(size: 16, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var mainStatsView: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                StatCard(
                    title: "Total Entries",
                    value: "\(statistics.totalEntries)",
                    icon: "calendar",
                    color: AppColors.info
                )
                
                StatCard(
                    title: "Current Streak",
                    value: "\(statistics.currentStreak) days",
                    icon: "flame",
                    color: AppColors.accent
                )
            }
            
            StatCard(
                title: "Best Streak",
                value: "\(statistics.bestStreak) days in a row",
                icon: "trophy",
                color: AppColors.success,
                isWide: true
            )
        }
    }
    
    private var monthlyDistributionView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Mood Distribution This Month")
                .font(FontManager.ubuntu(size: 20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ForEach(MoodType.allCases, id: \.self) { mood in
                    let count = statistics.monthlyDistribution[mood] ?? 0
                    let percentage = statistics.monthlyEntries > 0 ? 
                        Int((Double(count) / Double(statistics.monthlyEntries)) * 100) : 0
                    
                    MoodDistributionRow(
                        mood: mood,
                        count: count,
                        percentage: percentage
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 8)
        )
    }
    
    private var weeklyPatternsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Weekly Patterns (Last 8 Weeks)")
                .font(FontManager.ubuntu(size: 20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 10) {
                ForEach(Array(statistics.weeklyDistribution.sorted(by: { weekdayOrder($0.key) < weekdayOrder($1.key) })), id: \.key) { weekday, count in
                    WeeklyPatternRow(weekday: weekday, count: count)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 8)
        )
    }
    
    private var monthlySummaryView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("This Month Summary")
                .font(FontManager.ubuntu(size: 20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 15) {
                SummaryRow(
                    title: "Entries this month",
                    value: "\(statistics.monthlyEntries)",
                    icon: "checkmark.circle"
                )
                
                SummaryRow(
                    title: "Missed days",
                    value: "\(statistics.monthlyMissed)",
                    icon: "xmark.circle"
                )
                
                SummaryRow(
                    title: "Month completion",
                    value: "\(statistics.monthlyCompletion)%",
                    icon: "percent"
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 8)
        )
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.secondaryText.opacity(0.6))
            
            Text("Statistics will appear after the first mood entry")
                .font(FontManager.ubuntu(size: 18, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
    }
    
    private func weekdayOrder(_ weekday: String) -> Int {
        let order = ["Monday": 0, "Tuesday": 1, "Wednesday": 2, "Thursday": 3, "Friday": 4, "Saturday": 5, "Sunday": 6]
        return order[weekday] ?? 7
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var isWide: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(FontManager.ubuntu(size: isWide ? 24 : 20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(FontManager.ubuntu(size: 14, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 5)
        )
    }
}

struct MoodDistributionRow: View {
    let mood: MoodType
    let count: Int
    let percentage: Int
    
    var body: some View {
        HStack(spacing: 15) {
            Text(mood.rawValue)
                .font(.system(size: 24))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(mood.name)
                    .font(FontManager.ubuntu(size: 14, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(count) days (\(percentage)%)")
                    .font(FontManager.ubuntu(size: 12, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppColors.secondaryText.opacity(0.2))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(moodColor)
                        .frame(width: geometry.size.width * (Double(percentage) / 100.0), height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(width: 60, height: 6)
        }
    }
    
    private var moodColor: Color {
        switch mood {
        case .happy: return AppColors.happyMood
        case .calm: return AppColors.calmMood
        case .neutral: return AppColors.neutralMood
        case .sad: return AppColors.sadMood
        case .angry: return AppColors.angryMood
        }
    }
}

struct WeeklyPatternRow: View {
    let weekday: String
    let count: Int
    
    var body: some View {
        HStack {
            Text(weekday.prefix(3).uppercased())
                .font(FontManager.ubuntu(size: 14, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .frame(width: 40, alignment: .leading)
            
            Spacer()
            
            Text("\(count)")
                .font(FontManager.ubuntu(size: 16, weight: .bold))
                .foregroundColor(AppColors.accent)
        }
        .padding(.vertical, 4)
    }
}

struct SummaryRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.accent)
                .frame(width: 20)
            
            Text(title)
                .font(FontManager.ubuntu(size: 16, weight: .regular))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text(value)
                .font(FontManager.ubuntu(size: 16, weight: .bold))
                .foregroundColor(AppColors.accent)
        }
    }
}

#Preview {
    StatisticsView(dataManager: MoodDataManager())
}
