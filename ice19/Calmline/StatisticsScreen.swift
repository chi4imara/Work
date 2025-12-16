import SwiftUI
import Charts

struct StatisticsScreen: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTab: Int
    
    private var statistics: Statistics {
        dataManager.getStatistics()
    }
    
    var body: some View {
        ZStack {
            ColorManager.shared.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    if statistics.totalDays > 0 {
                        chartSection
                        
                        insightsSection
                        
                        summarySection
                    } else {
                        emptyStateSection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(ColorManager.shared.primaryPurple)
            }
            .disabled(true)
            .opacity(0)
            
            Spacer()
            
            Text("Mindfulness")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(ColorManager.shared.primaryBlue)
            
            Spacer()
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(ColorManager.shared.primaryPurple)
            }
            .disabled(true)
            .opacity(0)
        }
    }
    
    private var chartSection: some View {
        VStack(spacing: 16) {
            Text("What You Avoided Most Often")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.shared.primaryBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                ForEach(sortedHabitStats, id: \.key) { habit, count in
                    HabitStatBar(
                        habitName: habit,
                        count: count,
                        maxCount: maxHabitCount
                    )
                }
            }
        }
        .padding(20)
        .background(ColorManager.shared.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private var insightsSection: some View {
        VStack(spacing: 16) {
            Text("Insights")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.shared.primaryBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                ForEach(generateInsights(), id: \.self) { insight in
                    HStack {
                        Image(systemName: "lightbulb.circle.fill")
                            .foregroundColor(ColorManager.shared.primaryYellow)
                        
                        Text(insight)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorManager.shared.darkGray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(20)
        .background(ColorManager.shared.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private var summarySection: some View {
        VStack(spacing: 16) {
            Text("Summary")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.shared.primaryBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                SummaryCard(
                    title: "This Week",
                    value: "\(statistics.thisWeekCount)",
                    subtitle: "calm days",
                    color: ColorManager.shared.softGreen
                )
                
                SummaryCard(
                    title: "This Month",
                    value: "\(statistics.thisMonthCount)",
                    subtitle: "successful days",
                    color: ColorManager.shared.primaryPurple
                )
                
                SummaryCard(
                    title: "Current Streak",
                    value: "\(statistics.currentStreak)",
                    subtitle: "days in a row",
                    color: ColorManager.shared.primaryYellow
                )
                
                SummaryCard(
                    title: "Total Days",
                    value: "\(statistics.totalDays)",
                    subtitle: "mindful days",
                    color: ColorManager.shared.primaryBlue
                )
            }
        }
        .padding(20)
        .background(ColorManager.shared.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 30) {
            Image(systemName: "chart.bar")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorManager.shared.primaryPurple.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No data for analysis yet.")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(ColorManager.shared.primaryBlue)
                
                Text("Mark your calm days, and statistics will appear here.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.shared.darkGray)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                withAnimation {
                    selectedTab = 0
                }
            } label: {
                Text("Go to Today")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(ColorManager.shared.purpleGradient)
                    .cornerRadius(25)
                    .shadow(color: ColorManager.shared.primaryPurple.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.vertical, 40)
    }
        
    private var sortedHabitStats: [(key: String, value: Int)] {
        statistics.habitStats.sorted { $0.value > $1.value }
    }
    
    private var maxHabitCount: Int {
        statistics.habitStats.values.max() ?? 1
    }
        
    private func generateInsights() -> [String] {
        var insights: [String] = []
        
        let sortedStats = sortedHabitStats
        
        if let bestHabit = sortedStats.first, bestHabit.value > 0 {
            let habitName = bestHabit.key.lowercased().replacingOccurrences(of: "didn't ", with: "")
            if bestHabit.value >= 7 {
                insights.append("You've been \(bestHabit.value) days without \(habitName) — excellent result.")
            } else {
                insights.append("Good progress with avoiding \(habitName).")
            }
        }
        
        if let worstHabit = sortedStats.last, worstHabit.value < maxHabitCount / 2 && maxHabitCount > 2 {
            let habitName = worstHabit.key.lowercased().replacingOccurrences(of: "didn't ", with: "")
            insights.append("Small difficulties with \(habitName) — try to slow down tomorrow.")
        }
        
        if statistics.currentStreak >= 3 {
            insights.append("Great streak! You're building a strong habit of mindfulness.")
        }
        
        if insights.isEmpty {
            insights.append("Keep tracking your progress to see meaningful insights.")
        }
        
        return insights
    }
}

struct HabitStatBar: View {
    let habitName: String
    let count: Int
    let maxCount: Int
    
    private var percentage: Double {
        guard maxCount > 0 else { return 0 }
        return Double(count) / Double(maxCount)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(habitName.replacingOccurrences(of: "Didn't ", with: ""))
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorManager.shared.darkGray)
                
                Spacer()
                
                Text("\(count)")
                    .font(.ubuntu(14, weight: .bold))
                    .foregroundColor(ColorManager.shared.primaryBlue)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(ColorManager.shared.lightGray)
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [ColorManager.shared.primaryPurple, ColorManager.shared.primaryBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .cornerRadius(4)
                        .animation(.easeInOut(duration: 0.8), value: percentage)
                }
            }
            .frame(height: 8)
        }
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(ColorManager.shared.darkGray.opacity(0.8))
            
            Text(value)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.ubuntu(10, weight: .medium))
                .foregroundColor(ColorManager.shared.darkGray.opacity(0.6))
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.shared.primaryWhite)
                .shadow(color: color.opacity(0.2), radius: 4, x: 0, y: 2)
        )
    }
}

