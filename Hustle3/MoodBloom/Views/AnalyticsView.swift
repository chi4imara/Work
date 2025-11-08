import SwiftUI

struct AnalyticsView: View {
    @ObservedObject var moodViewModel: MoodViewModel
    @State private var selectedPeriod: AnalyticsPeriod = .month
    @State private var selectedMoodFilter: MoodType?
    
    private var periodEntries: [MoodEntry] {
        let entries = moodViewModel.getEntriesForPeriod(selectedPeriod)
        if let filter = selectedMoodFilter {
            return entries.filter { $0.mood == filter }
        }
        return entries
    }
    
    private var hasEnoughData: Bool {
        periodEntries.count >= 3
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                
                if hasEnoughData {
                    ScrollView {
                        VStack(spacing: 24) {
                            periodSelectorView
                            
                            moodChartView
                            
                            distributionChartView
                            
                            statisticsSummaryView
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                } else {
                    emptyStateView
                }
                
                Spacer()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Analytics")
                .font(FontManager.title)
                .foregroundColor(Color.textPrimary)
            
            Spacer()
            
            if selectedMoodFilter != nil {
                Button("Clear Filter") {
                    selectedMoodFilter = nil
                }
                .font(FontManager.body)
                .foregroundColor(Color.primaryBlue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var periodSelectorView: some View {
        HStack {
            ForEach(AnalyticsPeriod.allCases, id: \.self) { period in
                Spacer()
                
                Button(period.rawValue) {
                    withAnimation(.easeInOut) {
                        selectedPeriod = period
                        selectedMoodFilter = nil
                    }
                }
                .font(FontManager.body)
                .foregroundColor(selectedPeriod == period ? .white : Color.primaryBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(selectedPeriod == period ? Color.primaryBlue : Color.lightBlue.opacity(0.2))
                )
                
                Spacer()
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var moodChartView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Trend")
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
            
            MoodTrendChart(
                entries: periodEntries,
                period: selectedPeriod
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var distributionChartView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Distribution")
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
            
            MoodDistributionChart(
                entries: moodViewModel.getEntriesForPeriod(selectedPeriod),
                onMoodTapped: { mood in
                    withAnimation(.easeInOut) {
                        selectedMoodFilter = selectedMoodFilter == mood ? nil : mood
                    }
                }
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var statisticsSummaryView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Summary")
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
            
            let allPeriodEntries = moodViewModel.getEntriesForPeriod(selectedPeriod)
            let averageMood = moodViewModel.getAverageMood(for: allPeriodEntries)
            let mostFrequent = moodViewModel.getMostFrequentMood(for: allPeriodEntries)
            let bestDay = moodViewModel.getBestDay(for: allPeriodEntries)
            let worstDay = moodViewModel.getWorstDay(for: allPeriodEntries)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCard(
                    title: "Days Recorded",
                    value: "\(allPeriodEntries.count)",
                    icon: "calendar"
                )
                
                StatCard(
                    title: "Average Mood",
                    value: String(format: "%.1f", averageMood),
                    icon: "chart.line.uptrend.xyaxis",
                    subtitle: averageMoodEmoji(averageMood)
                )
                
                if let mostFrequent = mostFrequent {
                    StatCard(
                        title: "Most Frequent",
                        value: mostFrequent.emoji,
                        icon: "star.fill",
                        subtitle: mostFrequent.description
                    )
                }
                
                if let bestDay = bestDay {
                    StatCard(
                        title: "Best Day",
                        value: bestDay.mood.emoji,
                        icon: "arrow.up.circle.fill",
                        subtitle: formatDate(bestDay.date)
                    )
                }
                
                if let worstDay = worstDay {
                    StatCard(
                        title: "Worst Day",
                        value: worstDay.mood.emoji,
                        icon: "arrow.down.circle.fill",
                        subtitle: formatDate(worstDay.date)
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            periodSelectorView
                .padding(.horizontal, 20)
            
            VStack(spacing: 20) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(Color.primaryBlue.opacity(0.6))
                
                Text("Not enough data for analysis")
                    .font(FontManager.headline)
                    .foregroundColor(Color.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("You need at least 3 mood entries to see analytics")
                    .font(FontManager.body)
                    .foregroundColor(Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.backgroundWhite)
                    .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal, 20)
        }
    }
    
    private func averageMoodEmoji(_ average: Double) -> String {
        switch average {
        case ...(-1.5): return "😢"
        case -1.5...(-0.5): return "😟"
        case -0.5...0.5: return "😐"
        case 0.5...1.5: return "😊"
        default: return "😀"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let subtitle: String?
    
    init(title: String, value: String, icon: String, subtitle: String? = nil) {
        self.title = title
        self.value = value
        self.icon = icon
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.primaryBlue)
                
                Spacer()
            }
            
            Text(value)
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
            
            Text(title)
                .font(FontManager.caption)
                .foregroundColor(Color.textSecondary)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(FontManager.small)
                    .foregroundColor(Color.textSecondary.opacity(0.8))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundGray.opacity(0.3))
        )
    }
}

#Preview {
    AnalyticsView(moodViewModel: MoodViewModel())
}
