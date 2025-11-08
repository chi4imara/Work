import SwiftUI

struct EmotionInsightsView: View {
    @ObservedObject var dataManager: EmotionDataManager
    @State private var selectedInsightType: InsightType = .patterns
    
    private var recentEntries: [EmotionEntry] {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        return dataManager.entries.filter { $0.date >= thirtyDaysAgo }
    }
    
    private var emotionPatterns: [EmotionPattern] {
        analyzeEmotionPatterns()
    }
    
    private var moodTrends: [MoodTrend] {
        analyzeMoodTrends()
    }
    
    private var insights: [PersonalInsight] {
        generatePersonalInsights()
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Emotion Insights")
                        .font(.poppinsBold(size: 24))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        InsightTypeSelector(selectedType: $selectedInsightType)
                        
                        if recentEntries.isEmpty {
                            EmptyInsightsView()
                        } else {
                            Group {
                                switch selectedInsightType {
                                case .patterns:
                                    EmotionPatternsView(patterns: emotionPatterns)
                                case .trends:
                                    MoodTrendsView(trends: moodTrends)
                                case .personal:
                                    PersonalInsightsView(insights: insights)
                                }
                            }
                            
                            OverallSummaryView(entries: recentEntries)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    private func analyzeEmotionPatterns() -> [EmotionPattern] {
        var patterns: [EmotionPattern] = []
        
        let dayPatterns = analyzeDayOfWeekPatterns()
        patterns.append(contentsOf: dayPatterns)
        
        return patterns
    }
    
    private func analyzeDayOfWeekPatterns() -> [EmotionPattern] {
        let calendar = Calendar.current
        var dayEmotions: [Int: [EmotionType]] = [:]
        
        for entry in recentEntries {
            let weekday = calendar.component(.weekday, from: entry.date)
            dayEmotions[weekday, default: []].append(entry.emotion)
        }
        
        var patterns: [EmotionPattern] = []
        
        for (weekday, emotions) in dayEmotions {
            let emotionCounts = Dictionary(grouping: emotions, by: { $0 }).mapValues { $0.count }
            if let mostCommon = emotionCounts.max(by: { $0.value < $1.value }),
               mostCommon.value >= 2 {
                let dayName = calendar.weekdaySymbols[weekday - 1]
                patterns.append(EmotionPattern(
                    title: "\(dayName) Pattern",
                    description: "You often feel \(mostCommon.key.title.lowercased()) on \(dayName)s",
                    emotion: mostCommon.key,
                    frequency: mostCommon.value,
                    confidence: calculateConfidence(count: mostCommon.value, total: emotions.count)
                ))
            }
        }
        
        return patterns
    }
    
    private func analyzeMoodTrends() -> [MoodTrend] {
        var trends: [MoodTrend] = []
        
        let weeklyTrend = analyzeWeeklyTrend()
        if let trend = weeklyTrend {
            trends.append(trend)
        }
        
        let frequencyTrend = analyzeFrequencyTrend()
        if let trend = frequencyTrend {
            trends.append(trend)
        }
        
        return trends
    }
    
    private func analyzeWeeklyTrend() -> MoodTrend? {
        let calendar = Calendar.current
        let now = Date()
        
        guard let twoWeeksAgo = calendar.date(byAdding: .day, value: -14, to: now),
              let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now) else {
            return nil
        }
        
        let lastWeekEntries = recentEntries.filter { $0.date >= oneWeekAgo }
        let previousWeekEntries = recentEntries.filter { $0.date >= twoWeeksAgo && $0.date < oneWeekAgo }
        
        guard !lastWeekEntries.isEmpty && !previousWeekEntries.isEmpty else {
            return nil
        }
        
        let lastWeekScore = calculateMoodScore(entries: lastWeekEntries)
        let previousWeekScore = calculateMoodScore(entries: previousWeekEntries)
        
        let change = lastWeekScore - previousWeekScore
        let direction: TrendDirection = change > 0.1 ? .improving : (change < -0.1 ? .declining : .stable)
        
        return MoodTrend(
            title: "Weekly Mood Trend",
            description: getTrendDescription(direction: direction, change: abs(change)),
            direction: direction,
            changePercentage: abs(change) * 100
        )
    }
    
    private func analyzeFrequencyTrend() -> MoodTrend? {
        let calendar = Calendar.current
        let now = Date()
        
        guard let twoWeeksAgo = calendar.date(byAdding: .day, value: -14, to: now),
              let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now) else {
            return nil
        }
        
        let lastWeekCount = recentEntries.filter { $0.date >= oneWeekAgo }.count
        let previousWeekCount = recentEntries.filter { $0.date >= twoWeeksAgo && $0.date < oneWeekAgo }.count
        
        guard previousWeekCount > 0 else { return nil }
        
        let change = Double(lastWeekCount - previousWeekCount) / Double(previousWeekCount)
        let direction: TrendDirection = change > 0.2 ? .improving : (change < -0.2 ? .declining : .stable)
        
        return MoodTrend(
            title: "Entry Frequency",
            description: getFrequencyDescription(direction: direction, lastWeek: lastWeekCount, previousWeek: previousWeekCount),
            direction: direction,
            changePercentage: abs(change) * 100
        )
    }
    
    private func generatePersonalInsights() -> [PersonalInsight] {
        var insights: [PersonalInsight] = []
        
        let emotionCounts = Dictionary(grouping: recentEntries, by: { $0.emotion }).mapValues { $0.count }
        if let mostCommon = emotionCounts.max(by: { $0.value < $1.value }) {
            insights.append(PersonalInsight(
                title: "Your Dominant Emotion",
                description: "You've recorded \(mostCommon.key.title.lowercased()) \(mostCommon.value) times in the past 30 days. This represents \(Int(Double(mostCommon.value) / Double(recentEntries.count) * 100))% of your entries.",
                type: .positive,
                actionSuggestion: getEmotionSuggestion(for: mostCommon.key)
            ))
        }
        
        if let streakInsight = analyzeStreaks() {
            insights.append(streakInsight)
        }
        
        let uniqueEmotions = Set(recentEntries.map { $0.emotion }).count
        if uniqueEmotions >= 4 {
            insights.append(PersonalInsight(
                title: "Emotional Range",
                description: "You've experienced \(uniqueEmotions) different emotions recently, showing good emotional awareness and variety.",
                type: .positive,
                actionSuggestion: "Continue tracking to maintain this emotional awareness."
            ))
        }
        
        return insights
    }
    
    private func analyzeStreaks() -> PersonalInsight? {
        let calendar = Calendar.current
        let sortedEntries = recentEntries.sorted { $0.date < $1.date }
        
        var currentStreak = 0
        var maxStreak = 0
        var lastDate: Date?
        
        for entry in sortedEntries {
            if let last = lastDate {
                let daysDiff = calendar.dateComponents([.day], from: last, to: entry.date).day ?? 0
                if daysDiff == 1 {
                    currentStreak += 1
                } else {
                    maxStreak = max(maxStreak, currentStreak)
                    currentStreak = 1
                }
            } else {
                currentStreak = 1
            }
            lastDate = entry.date
        }
        
        maxStreak = max(maxStreak, currentStreak)
        
        if maxStreak >= 3 {
            return PersonalInsight(
                title: "Consistency Achievement",
                description: "Your longest tracking streak is \(maxStreak) days! Consistent tracking helps build better emotional awareness.",
                type: .achievement,
                actionSuggestion: "Try to maintain daily tracking to build even longer streaks."
            )
        }
        
        return nil
    }
    
    private func calculateMoodScore(entries: [EmotionEntry]) -> Double {
        let scores: [EmotionType: Double] = [
            .joy: 1.0,
            .success: 0.9,
            .calm: 0.7,
            .bored: 0.4,
            .tired: 0.3,
            .angry: 0.1
        ]
        
        let totalScore = entries.compactMap { scores[$0.emotion] }.reduce(0, +)
        return entries.isEmpty ? 0 : totalScore / Double(entries.count)
    }
    
    private func calculateConfidence(count: Int, total: Int) -> Double {
        return Double(count) / Double(total)
    }
    
    private func getTrendDescription(direction: TrendDirection, change: Double) -> String {
        switch direction {
        case .improving:
            return "Your mood has been improving over the past week. Keep up the positive momentum!"
        case .declining:
            return "Your mood seems to have dipped recently. Consider what might be affecting your wellbeing."
        case .stable:
            return "Your mood has been relatively stable over the past week."
        }
    }
    
    private func getFrequencyDescription(direction: TrendDirection, lastWeek: Int, previousWeek: Int) -> String {
        switch direction {
        case .improving:
            return "You've been more consistent with tracking (\(lastWeek) vs \(previousWeek) entries)."
        case .declining:
            return "You've tracked less frequently this week (\(lastWeek) vs \(previousWeek) entries)."
        case .stable:
            return "Your tracking frequency has remained steady (\(lastWeek) entries this week)."
        }
    }
    
    private func getEmotionSuggestion(for emotion: EmotionType) -> String {
        switch emotion {
        case .joy:
            return "Great to see so much joy! Consider noting what specifically brings you happiness."
        case .calm:
            return "Your calm nature is admirable. Share your relaxation techniques with others."
        case .success:
            return "Celebrate your achievements! Consider setting new goals to maintain momentum."
        case .tired:
            return "Consider improving sleep habits or managing stress levels."
        case .angry:
            return "Try identifying anger triggers and developing healthy coping strategies."
        case .bored:
            return "Explore new activities or hobbies to add excitement to your routine."
        }
    }
}

enum InsightType: String, CaseIterable {
    case patterns = "Patterns"
    case trends = "Trends"
    case personal = "Personal"
}

enum TrendDirection {
    case improving
    case declining
    case stable
}

struct EmotionPattern {
    let title: String
    let description: String
    let emotion: EmotionType
    let frequency: Int
    let confidence: Double
}

struct MoodTrend {
    let title: String
    let description: String
    let direction: TrendDirection
    let changePercentage: Double
}

struct PersonalInsight {
    let title: String
    let description: String
    let type: InsightType
    let actionSuggestion: String
    
    enum InsightType {
        case positive
        case warning
        case achievement
    }
}

struct InsightTypeSelector: View {
    @Binding var selectedType: InsightType
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(InsightType.allCases, id: \.self) { type in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedType = type
                    }
                }) {
                    Text(type.rawValue)
                        .font(.poppinsRegular(size: 14))
                        .foregroundColor(selectedType == type ? AppColors.primaryBlue : AppColors.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedType == type ? AppColors.accentYellow : AppColors.cardBackground)
                        .cornerRadius(20)
                }
            }
        }
    }
}

struct EmotionPatternsView: View {
    let patterns: [EmotionPattern]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Emotion Patterns")
                .font(.poppinsSemiBold(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            if patterns.isEmpty {
                Text("Not enough data to identify patterns yet. Keep tracking for a few more days!")
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .padding(20)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
            } else {
                ForEach(patterns.indices, id: \.self) { index in
                    PatternCard(pattern: patterns[index])
                }
            }
        }
    }
}

struct PatternCard: View {
    let pattern: EmotionPattern
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: pattern.emotion.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.accentYellow)
                
                Text(pattern.title)
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(Int(pattern.confidence * 100))%")
                    .font(.poppinsRegular(size: 12))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Text(pattern.description)
                .font(.poppinsRegular(size: 14))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}

struct MoodTrendsView: View {
    let trends: [MoodTrend]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Trends")
                .font(.poppinsSemiBold(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            if trends.isEmpty {
                Text("Need more data to analyze trends. Keep tracking for better insights!")
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .padding(20)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
            } else {
                ForEach(trends.indices, id: \.self) { index in
                    TrendCard(trend: trends[index])
                }
            }
        }
    }
}

struct TrendCard: View {
    let trend: MoodTrend
    
    private var trendIcon: String {
        switch trend.direction {
        case .improving: return "arrow.up.right"
        case .declining: return "arrow.down.right"
        case .stable: return "arrow.right"
        }
    }
    
    private var trendColor: Color {
        switch trend.direction {
        case .improving: return AppColors.successGreen
        case .declining: return AppColors.errorRed
        case .stable: return AppColors.accentYellow
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: trendIcon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(trendColor)
                
                Text(trend.title)
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                if trend.changePercentage > 0 {
                    Text("\(Int(trend.changePercentage))%")
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(trendColor)
                }
            }
            
            Text(trend.description)
                .font(.poppinsRegular(size: 14))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}

struct PersonalInsightsView: View {
    let insights: [PersonalInsight]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Personal Insights")
                .font(.poppinsSemiBold(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            if insights.isEmpty {
                Text("Keep tracking to unlock personalized insights about your emotional patterns!")
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .padding(20)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
            } else {
                ForEach(insights.indices, id: \.self) { index in
                    InsightCard(insight: insights[index])
                }
            }
        }
    }
}

struct InsightCard: View {
    let insight: PersonalInsight
    
    private var insightIcon: String {
        switch insight.type {
        case .positive: return "lightbulb.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .achievement: return "star.fill"
        }
    }
    
    private var insightColor: Color {
        switch insight.type {
        case .positive: return AppColors.successGreen
        case .warning: return AppColors.warningOrange
        case .achievement: return AppColors.accentYellow
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: insightIcon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(insightColor)
                
                Text(insight.title)
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            Text(insight.description)
                .font(.poppinsRegular(size: 14))
                .foregroundColor(AppColors.secondaryText)
            
            Text(insight.actionSuggestion)
                .font(.poppinsRegular(size: 12))
                .foregroundColor(insightColor)
                .italic()
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}

struct OverallSummaryView: View {
    let entries: [EmotionEntry]
    
    private var summaryStats: (totalDays: Int, averagePerWeek: Double, mostProductiveDays: [String]) {
        let uniqueDays = Set(entries.map { Calendar.current.startOfDay(for: $0.date) }).count
        let weeks = Double(uniqueDays) / 7.0
        let averagePerWeek = weeks > 0 ? Double(entries.count) / weeks : 0
        
        let dayOfWeekCounts = Dictionary(grouping: entries) { entry in
            Calendar.current.component(.weekday, from: entry.date)
        }.mapValues { $0.count }
        
        let sortedDays = dayOfWeekCounts.sorted { $0.value > $1.value }
        let topDays = sortedDays.prefix(2).map { Calendar.current.weekdaySymbols[$0.key - 1] }
        
        return (uniqueDays, averagePerWeek, topDays)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("30-Day Summary")
                .font(.poppinsSemiBold(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                SummaryRow(title: "Active Days", value: "\(summaryStats.totalDays)")
                SummaryRow(title: "Entries per Week", value: String(format: "%.1f", summaryStats.averagePerWeek))
                SummaryRow(title: "Most Active Days", value: summaryStats.mostProductiveDays.joined(separator: ", "))
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

struct SummaryRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.poppinsRegular(size: 14))
                .foregroundColor(AppColors.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(.poppinsMedium(size: 14))
                .foregroundColor(AppColors.primaryText)
        }
    }
}

struct EmptyInsightsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryText.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No Insights Yet")
                    .font(.poppinsBold(size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Start tracking your emotions to unlock personalized insights and patterns")
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
    }
}

#Preview {
    EmotionInsightsView(dataManager: EmotionDataManager())
}
