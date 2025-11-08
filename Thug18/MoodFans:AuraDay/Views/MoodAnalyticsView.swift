import SwiftUI

struct MoodAnalyticsView: View {
    @StateObject private var dataManager = MoodDataManager.shared
    @StateObject private var exportManager = ExportManager.shared
    @State private var selectedTimeRange: TimeRange = .month
    @State private var animateCharts = false
    @State private var scrollOffset: CGFloat = 0
    @State private var presentedSheet: SheetType?
    
    enum SheetType: Identifiable {
        case moodDetails(MoodEntry)
        case exportOptions
        case exportProgress(ExportProgressView.ExportType)
        case fileSaver(Data, String)
        
        var id: String {
            switch self {
            case .moodDetails(let entry):
                return "moodDetails_\(entry.id)"
            case .exportOptions:
                return "exportOptions"
            case .exportProgress(let type):
                return "exportProgress_\(type == .pdf ? "pdf" : "json")"
            case .fileSaver(_, let fileName):
                return "fileSaver_\(fileName)"
            }
        }
    }
    
    private let calendar = Calendar.current
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case quarter = "3 Months"
        case year = "Year"
        
        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .quarter: return 90
            case .year: return 365
            }
        }
    }
    
    private var filteredEntries: [MoodEntry] {
        let cutoffDate = calendar.date(byAdding: .day, value: -selectedTimeRange.days, to: Date()) ?? Date()
        return dataManager.moodEntries.filter { $0.date >= cutoffDate }
            .sorted { $0.date < $1.date }
    }
    
    private var moodTrends: [MoodTrendData] {
        let groupedByDay = Dictionary(grouping: filteredEntries) { entry in
            calendar.startOfDay(for: entry.date)
        }
        
        return groupedByDay.compactMap { (date, entries) in
            let averageHappiness = entries.map { $0.moodColor.happinessScore }.reduce(0, +) / Double(entries.count)
            return MoodTrendData(date: date, averageHappiness: averageHappiness, entryCount: entries.count)
        }.sorted { $0.date < $1.date }
    }
    
    private var moodDistribution: [(MoodColor, Int)] {
        let distribution = Dictionary(grouping: filteredEntries, by: { $0.moodColor })
            .mapValues { $0.count }
        return distribution.sorted { $0.value > $1.value }
    }
    
    private var insights: [MoodInsight] {
        generateInsights()
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                LazyVStack(spacing: AppTheme.Spacing.xl, pinnedViews: [.sectionHeaders]) {
                    Section {
                        VStack(spacing: 0) {
                            headerView
                            timeRangeSelector
                        }
                    } header: {
                        Color.clear.frame(height: 0)
                    }
                    
                    if filteredEntries.isEmpty {
                        emptyAnalyticsView
                    } else {
                        Section {
                            moodTimelineChart
                        }
                        
                        Section {
                            quickStatsGrid
                        }
                        
                        Section {
                            moodDistributionChart
                        }
                        
                        Section {
                            insightsSection
                        }
                        
                        Section {
                            weeklyComparisonView
                        }
                    }
                    
                    Color.clear.frame(height: 100)
                }
            }
            .coordinateSpace(name: "scroll")
        }
        .sheet(item: $presentedSheet) { sheetType in
            switch sheetType {
            case .moodDetails(let entry):
                MoodDetailSheet(entry: entry, isPresented: .constant(true))
            case .exportOptions:
                ExportOptionsView(
                    isPresented: .constant(true),
                    onExportPDF: {
                        presentedSheet = nil
                        exportToPDF()
                    },
                    onExportJSON: {
                        presentedSheet = nil
                        exportToJSON()
                    }
                )
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.visible)
            case .exportProgress(let type):
                ExportProgressView(
                    isPresented: .constant(true),
                    exportType: type
                )
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
            case .fileSaver(let data, let fileName):
                FileSaver(
                    data: data,
                    fileName: fileName,
                    mimeType: FileSaver.mimeType(for: fileName),
                    isPresented: .constant(true)
                )
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0).delay(0.3)) {
                animateCharts = true
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Mood Analytics")
                    .font(AppTheme.Fonts.largeTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text("Discover your emotional patterns")
                    .font(AppTheme.Fonts.callout)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            
            Spacer()
            
            Button(action: {
                presentedSheet = .exportOptions
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.lg - 35)
    }
    
    private var timeRangeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.sm) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTimeRange = range
                        }
                    }) {
                        Text(range.rawValue)
                            .font(AppTheme.Fonts.callout)
                            .foregroundColor(selectedTimeRange == range ? AppTheme.Colors.backgroundBlue : AppTheme.Colors.secondaryText)
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.vertical, AppTheme.Spacing.sm)
                            .background(
                                Capsule()
                                    .fill(selectedTimeRange == range ? AppTheme.Colors.accentYellow : Color.white.opacity(0.1))
                            )
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.top, AppTheme.Spacing.lg)
        }
    }
    
    private var moodTimelineChart: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Mood Timeline")
                .font(AppTheme.Fonts.title3)
                .foregroundColor(AppTheme.Colors.primaryText)
                .padding(.horizontal, AppTheme.Spacing.lg)
            
            fallbackTimelineChart
        }
    }
    
    private var fallbackTimelineChart: some View {
        VStack(spacing: 0) {
            if moodTrends.isEmpty {
                VStack(spacing: AppTheme.Spacing.md) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                    
                    Text("No timeline data available")
                        .font(AppTheme.Fonts.callout)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                    
                    Text("Add more mood entries to see your timeline")
                        .font(AppTheme.Fonts.caption1)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(AppTheme.Spacing.xl)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .fill(Color.white.opacity(0.1))
                )
            } else {
                VStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(Array(moodTrends.enumerated()), id: \.offset) { index, trend in
                    Button(action: {
                    }) {
                        HStack(spacing: AppTheme.Spacing.md) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(DateFormatter.shortDate.string(from: trend.date))
                                    .font(AppTheme.Fonts.caption1)
                                    .foregroundColor(AppTheme.Colors.tertiaryText)
                                
                                Text("\(trend.entryCount) entries")
                                    .font(AppTheme.Fonts.caption2)
                                    .foregroundColor(AppTheme.Colors.tertiaryText)
                            }
                            .frame(width: 80, alignment: .leading)
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.white.opacity(0.1))
                                        .frame(height: 12)
                                    
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(moodColor(for: trend.averageHappiness))
                                        .frame(width: animateCharts ? geometry.size.width * CGFloat(trend.averageHappiness / 10) : 0, height: 12)
                                        .animation(.easeOut(duration: 1.0).delay(max(0, 0.5 + Double(index) * 0.1)), value: animateCharts)
                                }
                            }
                            .frame(height: 12)
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(String(format: "%.1f", trend.averageHappiness))
                                    .font(AppTheme.Fonts.callout)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                    .fontWeight(.medium)
                                
                                Text(moodEmoji(for: trend.averageHappiness))
                                    .font(.system(size: 16))
                            }
                            .frame(width: 50, alignment: .trailing)
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                                .fill(Color.white.opacity(0.05))
                        )
                    }
                    .disabled(true)
                    .scaleEffect(animateCharts ? 1.0 : 0.95)
                    .opacity(animateCharts ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.6).delay(max(0, 0.5 + Double(index) * 0.1)), value: animateCharts)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .padding(.horizontal, AppTheme.Spacing.lg)
                
            
            HStack {
                Text("Scale: 0 (Low) - 10 (High)")
                    .font(AppTheme.Fonts.caption2)
                    .foregroundColor(AppTheme.Colors.tertiaryText)
                
                Spacer()
                
                HStack(spacing: AppTheme.Spacing.xs) {
                    Circle().fill(.red).frame(width: 8, height: 8)
                    Text("Low")
                        .font(AppTheme.Fonts.caption2)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                    
                    Circle().fill(.orange).frame(width: 8, height: 8)
                    Text("Medium")
                        .font(AppTheme.Fonts.caption2)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                    
                    Circle().fill(.green).frame(width: 8, height: 8)
                    Text("High")
                        .font(AppTheme.Fonts.caption2)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.top, AppTheme.Spacing.sm)
            }
        }
    }
    
    private func moodColor(for score: Double) -> Color {
        switch score {
        case 8...: return .green
        case 6..<8: return AppTheme.Colors.accentYellow
        case 4..<6: return .orange
        default: return .red
        }
    }
    
    private func moodEmoji(for score: Double) -> String {
        switch score {
        case 8...: return "😊"
        case 6..<8: return "🙂"
        case 4..<6: return "😐"
        default: return "😔"
        }
    }
    
    private var quickStatsGrid: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Quick Stats")
                .font(AppTheme.Fonts.title3)
                .foregroundColor(AppTheme.Colors.primaryText)
                .padding(.horizontal, AppTheme.Spacing.lg)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppTheme.Spacing.md) {
                AnalyticsStatCard(
                    title: "Total Entries",
                    value: "\(filteredEntries.count)",
                    subtitle: "in \(selectedTimeRange.rawValue.lowercased())",
                    icon: "chart.bar.fill",
                    color: AppTheme.Colors.primaryBlue,
                    delay: 0.1
                )
                
                AnalyticsStatCard(
                    title: "Average Mood",
                    value: String(format: "%.1f", averageMoodScore),
                    subtitle: "happiness score",
                    icon: "heart.fill",
                    color: .pink,
                    delay: 0.2
                )
                
                AnalyticsStatCard(
                    title: "Best Day",
                    value: bestMoodDay,
                    subtitle: "highest mood",
                    icon: "star.fill",
                    color: AppTheme.Colors.accentYellow,
                    delay: 0.3
                )
                
                AnalyticsStatCard(
                    title: "Consistency",
                    value: "\(consistencyPercentage)%",
                    subtitle: "tracking rate",
                    icon: "target",
                    color: .green,
                    delay: 0.4
                )
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
        }
    }
    
    private var moodDistributionChart: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Mood Distribution")
                .font(AppTheme.Fonts.title3)
                .foregroundColor(AppTheme.Colors.primaryText)
                .padding(.horizontal, AppTheme.Spacing.lg)
            
            VStack(spacing: AppTheme.Spacing.md) {
                ForEach(Array(moodDistribution.enumerated()), id: \.offset) { index, item in
                    let (moodColor, count) = item
                    let percentage = filteredEntries.isEmpty ? 0 : (count * 100) / filteredEntries.count
                    
                    AnalyticsDistributionRow(
                        moodColor: moodColor,
                        count: count,
                        percentage: percentage,
                        delay: Double(index) * 0.1,
                        isAnimated: animateCharts
                    ) {
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
        }
    }
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Insights & Patterns")
                .font(AppTheme.Fonts.title3)
                .foregroundColor(AppTheme.Colors.primaryText)
                .padding(.horizontal, AppTheme.Spacing.lg)
            
            VStack(spacing: AppTheme.Spacing.md) {
                ForEach(Array(insights.enumerated()), id: \.offset) { index, insight in
                    AnalyticsInsightCard(
                        insight: insight,
                        delay: Double(index) * 0.1
                    )
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
        }
    }
    
    private var weeklyComparisonView: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Weekly Comparison")
                .font(AppTheme.Fonts.title3)
                .foregroundColor(AppTheme.Colors.primaryText)
                .padding(.horizontal, AppTheme.Spacing.lg)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(getWeeklyData(), id: \.week) { weekData in
                        WeeklyComparisonCard(weekData: weekData)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
            }
        }
    }
    
    private var emptyAnalyticsView: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppTheme.Colors.accentYellow)
            
            VStack(spacing: AppTheme.Spacing.md) {
                Text("No Data for Analysis")
                    .font(AppTheme.Fonts.title2)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text("Start tracking your mood to see beautiful analytics and insights")
                    .font(AppTheme.Fonts.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.lg)
            }
        }
        .padding(.top, AppTheme.Spacing.xxl)
    }
    
    private var averageMoodScore: Double {
        guard !filteredEntries.isEmpty else { return 0 }
        let total = filteredEntries.map { $0.moodColor.happinessScore }.reduce(0, +)
        return total / Double(filteredEntries.count)
    }
    
    private var bestMoodDay: String {
        guard let bestEntry = filteredEntries.max(by: { $0.moodColor.happinessScore < $1.moodColor.happinessScore }) else {
            return "N/A"
        }
        return DateFormatter.shortWeekday.string(from: bestEntry.date)
    }
    
    private var consistencyPercentage: Int {
        let totalDays = selectedTimeRange.days
        let trackedDays = Set(filteredEntries.map { calendar.startOfDay(for: $0.date) }).count
        return totalDays > 0 ? (trackedDays * 100) / totalDays : 0
    }
    
    private func generateInsights() -> [MoodInsight] {
        var insights: [MoodInsight] = []
        
        if let mostCommon = moodDistribution.first {
            insights.append(MoodInsight(
                type: .pattern,
                title: "Most Common Mood",
                description: "\(mostCommon.0.displayName) appears \(mostCommon.1) times",
                icon: "star.circle.fill",
                color: mostCommon.0.color
            ))
        }
        
        let currentStreak = dataManager.getCurrentStreak()
        if currentStreak > 3 {
            insights.append(MoodInsight(
                type: .achievement,
                title: "Great Streak!",
                description: "You've tracked your mood for \(currentStreak) days in a row",
                icon: "flame.fill",
                color: .orange
            ))
        }
        
        if moodTrends.count >= 2 {
            let recent = moodTrends.suffix(2)
            let trend = recent.last!.averageHappiness - recent.first!.averageHappiness
            if trend > 0.5 {
                insights.append(MoodInsight(
                    type: .trend,
                    title: "Positive Trend",
                    description: "Your mood has been improving recently",
                    icon: "arrow.up.circle.fill",
                    color: .green
                ))
            } else if trend < -0.5 {
                insights.append(MoodInsight(
                    type: .trend,
                    title: "Declining Trend",
                    description: "Consider what might be affecting your mood",
                    icon: "arrow.down.circle.fill",
                    color: .orange
                ))
            }
        }
        
        return insights
    }
    
    private func getWeeklyData() -> [WeeklyData] {
        let weeks = stride(from: 0, to: 4, by: 1).compactMap { weekOffset -> WeeklyData? in
            guard let weekStart = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: Date()) else { return nil }
            guard let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart) else { return nil }
            
            let weekEntries = filteredEntries.filter { entry in
                entry.date >= weekStart && entry.date <= weekEnd
            }
            
            let averageMood = weekEntries.isEmpty ? 0 : weekEntries.map { $0.moodColor.happinessScore }.reduce(0, +) / Double(weekEntries.count)
            
            return WeeklyData(
                week: weekStart,
                averageMood: averageMood,
                entryCount: weekEntries.count
            )
        }
        
        return weeks.reversed()
    }
    
    private func exportToPDF() {
        let analyticsData = MoodAnalyticsData(
            totalEntries: filteredEntries.count,
            averageMood: averageMoodScore,
            bestDay: bestMoodDay,
            consistencyPercentage: consistencyPercentage,
            moodDistribution: moodDistribution
        )
        
        if let (data, fileName) = exportManager.getPDFData(
            entries: filteredEntries,
            timeRange: selectedTimeRange.rawValue,
            analytics: analyticsData
        ) {
            presentedSheet = .fileSaver(data, fileName)
        } else {
            print("PDF export failed: \(exportManager.exportError ?? "Unknown error")")
        }
    }
    
    private func exportToJSON() {
        if let (data, fileName) = exportManager.getJSONData(
            entries: filteredEntries,
            timeRange: selectedTimeRange.rawValue
        ) {
            presentedSheet = .fileSaver(data, fileName)
        } else {
            print("JSON export failed: \(exportManager.exportError ?? "Unknown error")")
        }
    }
    
    private func shareFile(url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            
            if let popover = activityViewController.popoverPresentationController {
                popover.sourceView = rootViewController.view
                popover.sourceRect = CGRect(x: rootViewController.view.bounds.midX, y: rootViewController.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            rootViewController.present(activityViewController, animated: true)
        }
    }
}

struct MoodTrendData: Identifiable {
    let id = UUID()
    let date: Date
    let averageHappiness: Double
    let entryCount: Int
}

struct MoodInsight {
    enum InsightType {
        case pattern, achievement, trend, recommendation
    }
    
    let type: InsightType
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct WeeklyData {
    let week: Date
    let averageMood: Double
    let entryCount: Int
}

struct AnalyticsStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    let delay: Double
    
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(AppTheme.Fonts.title2)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(AppTheme.Fonts.caption1)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                Text(subtitle)
                    .font(AppTheme.Fonts.caption2)
                    .foregroundColor(AppTheme.Colors.tertiaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .scaleEffect(animate ? 1.0 : 0.9)
        .opacity(animate ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

struct AnalyticsDistributionRow: View {
    let moodColor: MoodColor
    let count: Int
    let percentage: Int
    let delay: Double
    let isAnimated: Bool
    let action: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.md) {
                Circle()
                    .fill(moodColor.color)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(moodColor.displayName)
                        .font(AppTheme.Fonts.callout)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    Text(moodColor.emotion)
                        .font(AppTheme.Fonts.caption2)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
                
                Spacer()
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(moodColor.color)
                            .frame(width: animate ? geometry.size.width * CGFloat(percentage) / 100 : 0, height: 8)
                            .animation(.easeOut(duration: 1.0).delay(delay), value: animate)
                    }
                }
                .frame(width: 80, height: 8)
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(count)")
                        .font(AppTheme.Fonts.callout)
                        .foregroundColor(AppTheme.Colors.accentYellow)
                        .fontWeight(.medium)
                    
                    Text("\(percentage)%")
                        .font(AppTheme.Fonts.caption2)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
            }
            .padding(AppTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                    .fill(Color.white.opacity(0.05))
            )
        }
        .disabled(true)
        .onAppear {
            if isAnimated {
                animate = true
            }
        }
        .onChange(of: isAnimated) { newValue in
            if newValue {
                animate = true
            }
        }
    }
}

struct AnalyticsInsightCard: View {
    let insight: MoodInsight
    let delay: Double
    
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: insight.icon)
                .font(.system(size: 28))
                .foregroundColor(insight.color)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(insight.color.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text(insight.description)
                    .font(AppTheme.Fonts.callout)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            
            Spacer()
        }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(insight.color.opacity(0.2), lineWidth: 1)
                )
        )
        .scaleEffect(animate ? 1.0 : 0.95)
        .opacity(animate ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

struct WeeklyComparisonCard: View {
    let weekData: WeeklyData
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Text(DateFormatter.weekRange.string(from: weekData.week))
                .font(AppTheme.Fonts.caption1)
                .foregroundColor(AppTheme.Colors.tertiaryText)
            
            Circle()
                .fill(moodColor.opacity(0.8))
                .frame(width: 60, height: 60)
                .overlay(
                    Text(String(format: "%.1f", weekData.averageMood))
                        .font(AppTheme.Fonts.callout)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                )
            
            Text("\(weekData.entryCount) entries")
                .font(AppTheme.Fonts.caption2)
                .foregroundColor(AppTheme.Colors.tertiaryText)
        }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.white.opacity(0.1))
        )
        .frame(width: 100)
    }
    
    private var moodColor: Color {
        switch weekData.averageMood {
        case 8...: return .green
        case 6..<8: return AppTheme.Colors.accentYellow
        case 4..<6: return .orange
        default: return .red
        }
    }
}

struct MoodDetailSheet: View {
    let entry: MoodEntry
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Text("Mood Details")
                .font(AppTheme.Fonts.title2)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            
            Button("Close") {
                isPresented = false
            }
            .font(AppTheme.Fonts.buttonFont)
            .foregroundColor(AppTheme.Colors.primaryText)
        }
        .padding(AppTheme.Spacing.lg)
    }
}

extension MoodColor {
    var happinessScore: Double {
        switch self {
        case .red: return 6.0
        case .orange: return 7.0
        case .yellow: return 8.0
        case .green: return 7.5
        case .blue: return 8.5
        case .purple: return 9.0
        case .gray: return 4.0
        case .white: return 5.0
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()
    
    static let shortWeekday: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    static let weekRange: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
}

#Preview {
    MoodAnalyticsView()
}
