import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var dataManager: EmotionDataManager
    @State private var selectedTimeRange: TimeRange = .week
    @State private var showEmotionBreakdown = true
    
    private var filteredEntries: [EmotionEntry] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedTimeRange {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            return dataManager.entries.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return dataManager.entries.filter { $0.date >= monthAgo }
        case .threeMonths:
            let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now) ?? now
            return dataManager.entries.filter { $0.date >= threeMonthsAgo }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            return dataManager.entries.filter { $0.date >= yearAgo }
        }
    }
    
    private var emotionCounts: [EmotionCount] {
        let counts = Dictionary(grouping: filteredEntries, by: { $0.emotion })
            .mapValues { $0.count }
        
        return EmotionType.allCases.map { emotion in
            EmotionCount(emotion: emotion, count: counts[emotion] ?? 0)
        }
    }
    
    private var totalEntries: Int {
        filteredEntries.count
    }
    
    private var mostFrequentEmotion: EmotionType? {
        emotionCounts.max(by: { $0.count < $1.count })?.emotion
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                    HStack {
                        Text("Emotion Statistics")
                            .font(.poppinsBold(size: 24))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        TimeRangeSelector(selectedRange: $selectedTimeRange)
                        
                        if totalEntries == 0 {
                            Spacer()
                            Spacer()
                            
                            EmptyStatisticsView()
                        } else {
                            HStack(spacing: 16) {
                                StatCard(
                                    title: "Total Entries",
                                    value: "\(totalEntries)",
                                    icon: "doc.text.fill"
                                )
                                
                                StatCard(
                                    title: "Most Frequent",
                                    value: mostFrequentEmotion?.title ?? "None",
                                    icon: mostFrequentEmotion?.icon ?? "questionmark"
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Emotion Breakdown")
                                    .font(.poppinsSemiBold(size: 18))
                                    .foregroundColor(AppColors.primaryText)
                                
                                EmotionChartView(emotionCounts: emotionCounts)
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(AppColors.cardBackground)
                            .cornerRadius(16)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Detailed Breakdown")
                                    .font(.poppinsSemiBold(size: 18))
                                    .foregroundColor(AppColors.primaryText)
                                
                                ForEach(emotionCounts.sorted(by: { $0.count > $1.count }), id: \.emotion) { emotionCount in
                                    EmotionStatRow(emotionCount: emotionCount, total: totalEntries)
                                }
                            }
                            .padding(20)
                            .background(AppColors.cardBackground)
                            .cornerRadius(16)
                            
                            if selectedTimeRange != .week && filteredEntries.count > 7 {
                                WeeklyTrendView(entries: filteredEntries)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

enum TimeRange: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case threeMonths = "3 Months"
    case year = "Year"
}

struct EmotionCount {
    let emotion: EmotionType
    let count: Int
}

struct TimeRangeSelector: View {
    @Binding var selectedRange: TimeRange
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedRange = range
                        }
                    }) {
                        Text(range.rawValue)
                            .font(.poppinsRegular(size: 14))
                            .foregroundColor(selectedRange == range ? AppColors.primaryBlue : AppColors.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedRange == range ? AppColors.accentYellow : AppColors.cardBackground)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(AppColors.accentYellow)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.poppinsBold(size: 20))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(.poppinsRegular(size: 12))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}

struct EmotionChartView: View {
    let emotionCounts: [EmotionCount]
    
    private var chartData: [ChartDataPoint] {
        emotionCounts.filter { $0.count > 0 }.map { emotionCount in
            ChartDataPoint(
                emotion: emotionCount.emotion.title,
                count: emotionCount.count,
                color: colorForEmotion(emotionCount.emotion)
            )
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(chartData, id: \.emotion) { dataPoint in
                    VStack(spacing: 4) {
                        Text("\(dataPoint.count)")
                            .font(.poppinsRegular(size: 10))
                            .foregroundColor(AppColors.primaryText)
                        
                        Rectangle()
                            .fill(dataPoint.color)
                            .frame(width: 30, height: CGFloat(dataPoint.count) * 10 + 20)
                            .cornerRadius(4)
                        
                        Text(String(dataPoint.emotion.prefix(3)))
                            .font(.poppinsRegular(size: 10))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .frame(height: 120)
        }
    }
    
    private func colorForEmotion(_ emotion: EmotionType) -> Color {
        switch emotion {
        case .joy: return AppColors.accentYellow
        case .calm: return AppColors.accentYellow
        case .tired: return AppColors.secondaryText
        case .angry: return AppColors.errorRed
        case .bored: return AppColors.primaryText.opacity(0.6)
        case .success: return AppColors.successGreen
        }
    }
}

struct ChartDataPoint {
    let emotion: String
    let count: Int
    let color: Color
}

struct EmotionStatRow: View {
    let emotionCount: EmotionCount
    let total: Int
    
    private var percentage: Double {
        total > 0 ? Double(emotionCount.count) / Double(total) * 100 : 0
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: emotionCount.emotion.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(AppColors.accentYellow)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(emotionCount.emotion.title)
                    .font(.poppinsMedium(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(AppColors.primaryText.opacity(0.2))
                            .frame(height: 4)
                            .cornerRadius(2)
                        
                        Rectangle()
                            .fill(AppColors.accentYellow)
                            .frame(width: geometry.size.width * (percentage / 100), height: 4)
                            .cornerRadius(2)
                    }
                }
                .frame(height: 4)
            }
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(emotionCount.count)")
                    .font(.poppinsBold(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(Int(percentage))%")
                    .font(.poppinsRegular(size: 12))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
    }
}

struct WeeklyTrendView: View {
    let entries: [EmotionEntry]
    
    private var weeklyData: [WeeklyEmotionData] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: entries) { entry in
            calendar.dateInterval(of: .weekOfYear, for: entry.date)?.start ?? entry.date
        }
        
        return grouped.map { (weekStart, weekEntries) in
            let emotionCounts = Dictionary(grouping: weekEntries, by: { $0.emotion })
                .mapValues { $0.count }
            let mostFrequent = emotionCounts.max(by: { $0.value < $1.value })?.key
            
            return WeeklyEmotionData(
                weekStart: weekStart,
                totalEntries: weekEntries.count,
                mostFrequentEmotion: mostFrequent
            )
        }.sorted { $0.weekStart < $1.weekStart }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Trend")
                .font(.poppinsSemiBold(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            ForEach(weeklyData, id: \.weekStart) { weekData in
                WeeklyTrendRow(weekData: weekData)
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

struct WeeklyEmotionData {
    let weekStart: Date
    let totalEntries: Int
    let mostFrequentEmotion: EmotionType?
}

struct WeeklyTrendRow: View {
    let weekData: WeeklyEmotionData
    
    private var weekString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: weekData.weekStart)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Week of \(weekString)")
                    .font(.poppinsMedium(size: 14))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(weekData.totalEntries) entries")
                    .font(.poppinsRegular(size: 12))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            if let emotion = weekData.mostFrequentEmotion {
                HStack(spacing: 8) {
                    Image(systemName: emotion.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                    
                    Text(emotion.title)
                        .font(.poppinsRegular(size: 14))
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryText.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No Data Available")
                    .font(.poppinsBold(size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Start adding emotion entries to see your statistics")
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
    }
}

#Preview {
    StatisticsView(dataManager: EmotionDataManager())
}
