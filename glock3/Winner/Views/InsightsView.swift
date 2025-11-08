import SwiftUI

struct InsightsView: View {
    @ObservedObject var store: VictoryStore
    @State private var selectedTimeRange: TimeRange = .month
    @State private var selectedInsight: InsightType = .overview
    @State private var showingDetailView = false
    @State private var selectedDetailData: Any?
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                            .opacity(0)
                    }
                    .disabled(true)
                    
                    Text("Insights")
                        .font(AppFonts.navigationTitle)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                
                if store.victories.isEmpty {
                    EmptyStateView(
                        iconName: "chart.line.uptrend.xyaxis",
                        title: "No Data Yet",
                        subtitle: "Add some victories to see detailed insights and analytics",
                        buttonTitle: "Go to Feed"
                    ) {
                        selectedTab = .feed
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            TimeRangeSelectorView(selectedRange: $selectedTimeRange)
                            
                            InsightTypeSelectorView(selectedType: $selectedInsight)
                            
                            switch selectedInsight {
                            case .overview:
                                OverviewInsightView(store: store, timeRange: selectedTimeRange)
                            case .trends:
                                TrendsInsightView(store: store, timeRange: selectedTimeRange)
                            case .patterns:
                                PatternsInsightView(store: store, timeRange: selectedTimeRange)
                            case .achievements:
                                AchievementsInsightView(store: store, timeRange: selectedTimeRange)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
    }
}

struct TimeRangeSelectorView: View {
    @Binding var selectedRange: TimeRange
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedRange = range
                        }
                    } label: {
                        Text(range.title)
                            .font(AppFonts.callout)
                            .foregroundColor(selectedRange == range ? .black : AppColors.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(selectedRange == range ? AppColors.primaryYellow : AppColors.cardBackground)
                            .cornerRadius(20)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
}

struct InsightTypeSelectorView: View {
    @Binding var selectedType: InsightType
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(InsightType.allCases, id: \.self) { type in
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedType = type
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: type.iconName)
                                .font(.title2)
                                .foregroundColor(selectedType == type ? .black : AppColors.textSecondary)
                            
                            Text(type.title)
                                .font(AppFonts.caption1)
                                .foregroundColor(selectedType == type ? .black : AppColors.textSecondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(selectedType == type ? AppColors.primaryYellow : AppColors.cardBackground)
                        .cornerRadius(16)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
}

struct OverviewInsightView: View {
    @ObservedObject var store: VictoryStore
    let timeRange: TimeRange
    
    private var filteredVictories: [Victory] {
        store.victories.filter { victory in
            let daysAgo = timeRange.days
            let cutoffDate = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
            return victory.date >= cutoffDate
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                MetricCardView(
                    title: "Total Victories",
                    value: "\(filteredVictories.count)",
                    iconName: "trophy.fill",
                    color: AppColors.primaryYellow,
                    trend: calculateTrend()
                )
                
                MetricCardView(
                    title: "Average per Day",
                    value: String(format: "%.1f", Double(filteredVictories.count) / Double(timeRange.days)),
                    iconName: "calendar",
                    color: AppColors.accentGreen,
                    trend: nil
                )
                
                MetricCardView(
                    title: "Best Day",
                    value: "\(getBestDayCount())",
                    iconName: "star.fill",
                    color: AppColors.accentOrange,
                    trend: nil
                )
                
                MetricCardView(
                    title: "Current Streak",
                    value: "\(store.getCurrentStreak())",
                    iconName: "flame.fill",
                    color: AppColors.accentPurple,
                    trend: nil
                )
            }
            
            QuickInsightsView(store: store, victories: filteredVictories)
        }
    }
    
    private func calculateTrend() -> TrendDirection? {
        guard filteredVictories.count >= 2 else { return nil }
        
        let calendar = Calendar.current
        let now = Date()
        let halfPeriod = timeRange.days / 2
        let midPoint = calendar.date(byAdding: .day, value: -halfPeriod, to: now) ?? now
        
        let recentCount = filteredVictories.filter { $0.date >= midPoint }.count
        let olderCount = filteredVictories.filter { $0.date < midPoint }.count
        
        if recentCount > olderCount {
            return .up
        } else if recentCount < olderCount {
            return .down
        } else {
            return .stable
        }
    }
    
    private func getBestDayCount() -> Int {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredVictories) { victory in
            calendar.startOfDay(for: victory.date)
        }
        return grouped.values.map { $0.count }.max() ?? 0
    }
}

struct InteractiveChartView: View {
    let victories: [Victory]
    let timeRange: TimeRange
    @State private var selectedDate: Date?
    @State private var chartData: [ChartDataPoint] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Victory Timeline")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                if let selectedDate = selectedDate {
                    Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            GeometryReader { geometry in
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.cardBorder, lineWidth: 1)
                        )
                    
                    if !chartData.isEmpty {
                        LineChartView(
                            data: chartData,
                            selectedDate: $selectedDate,
                            geometry: geometry
                        )
                    }
                }
            }
            .frame(height: 200)
        }
        .onAppear {
            generateChartData()
        }
        .onChange(of: victories) { _ in
            generateChartData()
        }
    }
    
    private func generateChartData() {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -timeRange.days, to: endDate) ?? endDate
        
        var dataPoints: [ChartDataPoint] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            let dayStart = calendar.startOfDay(for: currentDate)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart
            
            let dayVictories = victories.filter { victory in
                victory.date >= dayStart && victory.date < dayEnd
            }
            
            dataPoints.append(ChartDataPoint(
                date: dayStart,
                value: dayVictories.count,
                victories: dayVictories
            ))
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        chartData = dataPoints
    }
}

struct LineChartView: View {
    let data: [ChartDataPoint]
    @Binding var selectedDate: Date?
    let geometry: GeometryProxy
    
    private var maxValue: Int {
        data.map { $0.value }.max() ?? 1
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
            
            if data.isEmpty {
                VStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title2)
                        .foregroundColor(AppColors.textTertiary)
                    Text("No data available")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textTertiary)
                }
            } else {
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(0..<5) { index in
                                let value = maxValue - (maxValue * index / 4)
                                Text("\(value)")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppColors.textTertiary)
                                    .frame(height: geometry.size.height / 4)
                            }
                        }
                        .frame(width: 30)
                        
                        ZStack {
                            ForEach(0..<5) { index in
                                let y = geometry.size.height * CGFloat(index) / 4
                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: y))
                                    path.addLine(to: CGPoint(x: geometry.size.width - 30, y: y))
                                }
                                .stroke(AppColors.cardBorder.opacity(0.2), lineWidth: 0.5)
                            }
                            
                            if data.count > 1 {
                                Path { path in
                                    for (index, point) in data.enumerated() {
                                        let x = (geometry.size.width - 30) * CGFloat(index) / CGFloat(data.count - 1)
                                        let y = geometry.size.height * (1 - CGFloat(point.value) / CGFloat(maxValue))
                                        
                                        if index == 0 {
                                            path.move(to: CGPoint(x: x, y: y))
                                        } else {
                                            path.addLine(to: CGPoint(x: x, y: y))
                                        }
                                    }
                                }
                                .stroke(AppColors.primaryYellow, lineWidth: 2)
                            }
                            
                            ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                                let x = (geometry.size.width - 30) * CGFloat(index) / CGFloat(data.count - 1)
                                let y = geometry.size.height * (1 - CGFloat(point.value) / CGFloat(maxValue))
                                
                                Circle()
                                    .fill(AppColors.primaryYellow)
                                    .frame(width: 6, height: 6)
                                    .position(x: x, y: y)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            selectedDate = point.date
                                        }
                                    }
                            }
                        }
                        .frame(width: geometry.size.width - 30)
                    }
                    
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width: 30)
                        
                        ForEach(0..<min(data.count, 7)) { index in
                            let pointIndex = data.count > 7 ? index * (data.count - 1) / 6 : index
                            if pointIndex < data.count {
                                Text(data[pointIndex].date.formatted(.dateTime.day().month(.abbreviated)))
                                    .font(.system(size: 10))
                                    .foregroundColor(AppColors.textTertiary)
                                    .frame(width: (geometry.size.width - 30) / CGFloat(min(data.count, 7)))
                            }
                        }
                    }
                    .frame(height: 20)
                }
            }
        }
        .padding(16)
    }
}

struct QuickInsightsView: View {
    @ObservedObject var store: VictoryStore
    let victories: [Victory]
    
    private var insights: [String] {
        var result: [String] = []
        
        let total = victories.count
        let streak = store.getCurrentStreak()
        
        if total == 0 {
            result.append("Start your journey by adding your first victory!")
        } else if streak > 7 {
            result.append("🔥 Amazing! You're on a \(streak)-day streak!")
        } else if total > 50 {
            result.append("🎉 Incredible! You've reached \(total) total victories!")
        } else if total > 10 {
            result.append("💪 Great progress! You've logged \(total) victories!")
        } else {
            result.append("🌟 You're building momentum with \(total) victories!")
        }
        
        let categories = Set(victories.compactMap { $0.category })
        if categories.count > 3 {
            result.append("📊 You're exploring \(categories.count) different categories!")
        }
        
        return result
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.title3)
                    .foregroundColor(AppColors.primaryYellow)
                
                Text("Quick Insights")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(insights, id: \.self) { insight in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.primaryYellow)
                        
                        Text(insight)
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct MetricCardView: View {
    let title: String
    let value: String
    let iconName: String
    let color: Color
    let trend: TrendDirection?
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: iconName)
                    .font(.title3)
                    .foregroundColor(color)
                
                Spacer()
                
                if let trend = trend {
                    Image(systemName: trend.iconName)
                        .font(.caption)
                        .foregroundColor(trend.color)
                }
            }
            
            Text(value)
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.textPrimary)
            
            Text(title)
                .font(AppFonts.caption1)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct ChartDataPoint {
    let date: Date
    let value: Int
    let victories: [Victory]
}

enum TimeRange: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case quarter = "Quarter"
    case year = "Year"
    
    var title: String {
        return rawValue
    }
    
    var days: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .quarter: return 90
        case .year: return 365
        }
    }
}

enum InsightType: String, CaseIterable {
    case overview = "Overview"
    case trends = "Trends"
    case patterns = "Patterns"
    case achievements = "Achievements"
    
    var title: String {
        return rawValue
    }
    
    var iconName: String {
        switch self {
        case .overview: return "chart.bar.fill"
        case .trends: return "chart.line.uptrend.xyaxis"
        case .patterns: return "waveform.path.ecg"
        case .achievements: return "trophy.fill"
        }
    }
}

enum TrendDirection {
    case up, down, stable
    
    var iconName: String {
        switch self {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .stable: return "minus"
        }
    }
    
    var color: Color {
        switch self {
        case .up: return AppColors.success
        case .down: return AppColors.error
        case .stable: return AppColors.textSecondary
        }
    }
}

struct TrendsInsightView: View {
    @ObservedObject var store: VictoryStore
    let timeRange: TimeRange
    
    private var filteredVictories: [Victory] {
        store.victories.filter { victory in
            let daysAgo = timeRange.days
            let cutoffDate = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
            return victory.date >= cutoffDate
        }
    }
    
    private var weeklyTrends: [WeeklyTrend] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredVictories) { victory in
            calendar.dateInterval(of: .weekOfYear, for: victory.date)?.start ?? victory.date
        }
        
        return grouped.map { (weekStart, victories) in
            WeeklyTrend(
                weekStart: weekStart,
                count: victories.count,
                categories: Set(victories.compactMap { $0.category })
            )
        }.sorted { $0.weekStart < $1.weekStart }
    }
    
    private var categoryTrends: [CategoryTrend] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredVictories) { $0.category ?? "Uncategorized" }
        
        return grouped.map { (category, victories) in
            let weeklyData = Dictionary(grouping: victories) { victory in
                calendar.dateInterval(of: .weekOfYear, for: victory.date)?.start ?? victory.date
            }
            
            return CategoryTrend(
                name: category,
                totalCount: victories.count,
                weeklyData: weeklyData.mapValues { $0.count }
            )
        }.sorted { $0.totalCount > $1.totalCount }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            WeeklyTrendsChartView(trends: weeklyTrends)
            
            CategoryTrendsView(trends: categoryTrends)
            
            TrendAnalysisView(store: store, victories: filteredVictories)
        }
    }
}

struct WeeklyTrendsChartView: View {
    let trends: [WeeklyTrend]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title3)
                    .foregroundColor(AppColors.accentGreen)
                
                Text("Weekly Trends")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            if trends.isEmpty {
                VStack {
                    Image(systemName: "chart.bar")
                        .font(.title2)
                        .foregroundColor(AppColors.textTertiary)
                    Text("No data available")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textTertiary)
                }
                .frame(height: 120)
            } else {
                GeometryReader { geometry in
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(Array(trends.enumerated()), id: \.offset) { index, trend in
                            VStack(spacing: 4) {
                                Text("\(trend.count)")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppColors.textSecondary)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppColors.accentGreen)
                                    .frame(
                                        width: max(8, geometry.size.width / CGFloat(trends.count) - 8),
                                        height: max(4, CGFloat(trend.count) / CGFloat(trends.map { $0.count }.max() ?? 1) * 80)
                                    )
                                
                                Text(trend.weekStart.formatted(.dateTime.day().month(.abbreviated)))
                                    .font(.system(size: 8))
                                    .foregroundColor(AppColors.textTertiary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 120)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct CategoryTrendsView: View {
    let trends: [CategoryTrend]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .font(.title3)
                    .foregroundColor(AppColors.accentOrange)
                
                Text("Category Trends")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            if trends.isEmpty {
                Text("No categories found")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textTertiary)
            } else {
                VStack(spacing: 8) {
                    ForEach(trends.prefix(5), id: \.name) { trend in
                        HStack {
                            Text(trend.name)
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.textSecondary)
                            
                            Spacer()
                            
                            Text("\(trend.totalCount)")
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.textPrimary)
                            
                            if trend.weeklyData.count > 1 {
                                let recent = trend.weeklyData.values.suffix(1).first ?? 0
                                let previous = trend.weeklyData.values.dropLast().last ?? 0
                                
                                Image(systemName: recent > previous ? "arrow.up" : recent < previous ? "arrow.down" : "minus")
                                    .font(.caption)
                                    .foregroundColor(recent > previous ? AppColors.success : recent < previous ? AppColors.error : AppColors.textTertiary)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct TrendAnalysisView: View {
    @ObservedObject var store: VictoryStore
    let victories: [Victory]
    
    private var analysis: String {
        let total = victories.count
        let calendar = Calendar.current
        let now = Date()
        
        if total == 0 {
            return "Start adding victories to see trends!"
        }
        
        let halfPeriod = victories.count > 10 ? 10 : victories.count / 2
        let recent = victories.suffix(halfPeriod).count
        let older = victories.prefix(halfPeriod).count
        
        if recent > older {
            return "📈 Upward trend! You've been more active recently with \(recent) victories in the last period."
        } else if recent < older {
            return "📉 Activity has slowed down. You had \(older) victories in the earlier period vs \(recent) recently."
        } else {
            return "📊 Steady progress! You're maintaining consistent activity with \(recent) victories in each period."
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.title3)
                    .foregroundColor(AppColors.accentPurple)
                
                Text("Trend Analysis")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            Text(analysis)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct WeeklyTrend {
    let weekStart: Date
    let count: Int
    let categories: Set<String>
}

struct CategoryTrend {
    let name: String
    let totalCount: Int
    let weeklyData: [Date: Int]
}

struct PatternsInsightView: View {
    @ObservedObject var store: VictoryStore
    let timeRange: TimeRange
    
    private var filteredVictories: [Victory] {
        store.victories.filter { victory in
            let daysAgo = timeRange.days
            let cutoffDate = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
            return victory.date >= cutoffDate
        }
    }
    
    private var dayOfWeekPattern: [DayPattern] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredVictories) { victory in
            calendar.component(.weekday, from: victory.date)
        }
        
        let dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        
        return (1...7).map { day in
            DayPattern(
                dayName: dayNames[day - 1],
                count: grouped[day]?.count ?? 0,
                percentage: Double(grouped[day]?.count ?? 0) / Double(filteredVictories.count) * 100
            )
        }
    }
    
    private var timeOfDayPattern: [TimePattern] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredVictories) { victory in
            calendar.component(.hour, from: victory.date)
        }
        
        let timeSlots = [
            (0...5, "Night"),
            (6...11, "Morning"),
            (12...17, "Afternoon"),
            (18...23, "Evening")
        ]
        
        return timeSlots.map { (range, name) -> TimePattern in
            let count = grouped.filter { range.contains($0.key) }.values.flatMap { $0 }.count
            return TimePattern(
                timeSlot: name,
                count: count,
                percentage: Double(count) / Double(filteredVictories.count) * 100
            )
        }
    }
    
    private var categoryPattern: [CategoryPattern] {
        let grouped = Dictionary(grouping: filteredVictories) { $0.category ?? "Uncategorized" }
        
        return grouped.map { (category, victories) in
            CategoryPattern(
                name: category,
                count: victories.count,
                percentage: Double(victories.count) / Double(filteredVictories.count) * 100,
                avgPerDay: Double(victories.count) / Double(timeRange.days)
            )
        }.sorted { $0.count > $1.count }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            DayOfWeekPatternView(patterns: dayOfWeekPattern)
            
            TimeOfDayPatternView(patterns: timeOfDayPattern)
            
            CategoryPatternView(patterns: categoryPattern)
            
            PatternInsightsView(victories: filteredVictories, dayPattern: dayOfWeekPattern, timePattern: timeOfDayPattern)
        }
    }
}

struct DayOfWeekPatternView: View {
    let patterns: [DayPattern]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .font(.title3)
                    .foregroundColor(AppColors.primaryYellow)
                
                Text("Day of Week Pattern")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 8) {
                ForEach(patterns, id: \.dayName) { pattern in
                    HStack {
                        Text(pattern.dayName)
                            .font(Font.custom("Raleway-Regular", size: 13))
                            .foregroundColor(AppColors.textSecondary)
                            .frame(width: 80, alignment: .leading)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppColors.cardBorder.opacity(0.3))
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppColors.primaryYellow)
                                    .frame(width: geometry.size.width * CGFloat(pattern.percentage) / 100, height: 8)
                            }
                        }
                        .frame(height: 8)
                        
                        Text("\(pattern.count)")
                            .font(AppFonts.caption1)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct TimeOfDayPatternView: View {
    let patterns: [TimePattern]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "clock")
                    .font(.title3)
                    .foregroundColor(AppColors.accentGreen)
                
                Text("Time of Day Pattern")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(patterns, id: \.timeSlot) { pattern in
                    VStack(spacing: 8) {
                        Text(pattern.timeSlot)
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text("\(pattern.count)")
                            .font(AppFonts.largeTitle)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("\(Int(pattern.percentage))%")
                            .font(AppFonts.caption1)
                            .foregroundColor(AppColors.textTertiary)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.cardBackground.opacity(0.5))
                    .cornerRadius(12)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct CategoryPatternView: View {
    let patterns: [CategoryPattern]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "folder.fill")
                    .font(.title3)
                    .foregroundColor(AppColors.accentOrange)
                
                Text("Category Distribution")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 8) {
                ForEach(patterns.prefix(5), id: \.name) { pattern in
                    HStack {
                        Text(pattern.name)
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(pattern.count)")
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("\(Int(pattern.percentage))%")
                                .font(AppFonts.caption2)
                                .foregroundColor(AppColors.textTertiary)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct PatternInsightsView: View {
    let victories: [Victory]
    let dayPattern: [DayPattern]
    let timePattern: [TimePattern]
    
    private var insights: [String] {
        var result: [String] = []
        
        if let mostActiveDay = dayPattern.max(by: { $0.count < $1.count }) {
            if mostActiveDay.count > 0 {
                result.append("📅 You're most active on \(mostActiveDay.dayName)s with \(mostActiveDay.count) victories.")
            }
        }
        
        if let mostActiveTime = timePattern.max(by: { $0.count < $1.count }) {
            if mostActiveTime.count > 0 {
                result.append("⏰ You prefer logging victories in the \(mostActiveTime.timeSlot.lowercased()) (\(mostActiveTime.count) victories).")
            }
        }
        
        let activeDays = dayPattern.filter { $0.count > 0 }.count
        if activeDays >= 5 {
            result.append("🎯 Great consistency! You're active \(activeDays) days a week.")
        } else if activeDays >= 3 {
            result.append("💪 Good consistency! You're active \(activeDays) days a week.")
        } else if activeDays > 0 {
            result.append("🌟 Building habits! You're active \(activeDays) days a week.")
        }
        
        return result
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.title3)
                    .foregroundColor(AppColors.accentPurple)
                
                Text("Pattern Insights")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(insights, id: \.self) { insight in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.accentPurple)
                        
                        Text(insight)
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct DayPattern {
    let dayName: String
    let count: Int
    let percentage: Double
}

struct TimePattern {
    let timeSlot: String
    let count: Int
    let percentage: Double
}

struct CategoryPattern {
    let name: String
    let count: Int
    let percentage: Double
    let avgPerDay: Double
}

struct AchievementsInsightView: View {
    @ObservedObject var store: VictoryStore
    let timeRange: TimeRange
    
    private var filteredVictories: [Victory] {
        store.victories.filter { victory in
            let daysAgo = timeRange.days
            let cutoffDate = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
            return victory.date >= cutoffDate
        }
    }
    
    private var achievements: [Achievement] {
        var result: [Achievement] = []
        let total = filteredVictories.count
        let streak = store.getCurrentStreak()
        
        if total >= 1 && !result.contains(where: { $0.id == "first_victory" }) {
            result.append(Achievement(
                id: "first_victory",
                title: "First Steps",
                description: "Logged your first victory!",
                iconName: "star.fill",
                color: AppColors.primaryYellow,
                isUnlocked: true,
                progress: 1.0
            ))
        }
        
        if total >= 10 && !result.contains(where: { $0.id == "ten_victories" }) {
            result.append(Achievement(
                id: "ten_victories",
                title: "Getting Started",
                description: "Reached 10 victories!",
                iconName: "trophy.fill",
                color: AppColors.accentGreen,
                isUnlocked: true,
                progress: 1.0
            ))
        }
        
        if total >= 50 && !result.contains(where: { $0.id == "fifty_victories" }) {
            result.append(Achievement(
                id: "fifty_victories",
                title: "Half Century",
                description: "Reached 50 victories!",
                iconName: "crown.fill",
                color: AppColors.accentOrange,
                isUnlocked: true,
                progress: 1.0
            ))
        }
        
        if total >= 100 && !result.contains(where: { $0.id == "hundred_victories" }) {
            result.append(Achievement(
                id: "hundred_victories",
                title: "Century",
                description: "Reached 100 victories!",
                iconName: "medal.fill",
                color: AppColors.accentPurple,
                isUnlocked: true,
                progress: 1.0
            ))
        }
        
        if streak >= 3 && !result.contains(where: { $0.id == "three_day_streak" }) {
            result.append(Achievement(
                id: "three_day_streak",
                title: "On Fire",
                description: "3-day streak!",
                iconName: "flame.fill",
                color: AppColors.accentOrange,
                isUnlocked: true,
                progress: 1.0
            ))
        }
        
        if streak >= 7 && !result.contains(where: { $0.id == "week_streak" }) {
            result.append(Achievement(
                id: "week_streak",
                title: "Week Warrior",
                description: "7-day streak!",
                iconName: "calendar.badge.clock",
                color: AppColors.accentGreen,
                isUnlocked: true,
                progress: 1.0
            ))
        }
        
        if streak >= 30 && !result.contains(where: { $0.id == "month_streak" }) {
            result.append(Achievement(
                id: "month_streak",
                title: "Consistency Master",
                description: "30-day streak!",
                iconName: "calendar.badge.checkmark",
                color: AppColors.accentPurple,
                isUnlocked: true,
                progress: 1.0
            ))
        }
        
        let categories = Set(filteredVictories.compactMap { $0.category })
        if categories.count >= 3 && !result.contains(where: { $0.id == "explorer" }) {
            result.append(Achievement(
                id: "explorer",
                title: "Explorer",
                description: "Used 3+ categories!",
                iconName: "map.fill",
                color: AppColors.accentGreen,
                isUnlocked: true,
                progress: 1.0
            ))
        }
        
        if categories.count >= 5 && !result.contains(where: { $0.id == "diversifier" }) {
            result.append(Achievement(
                id: "diversifier",
                title: "Diversifier",
                description: "Used 5+ categories!",
                iconName: "square.grid.3x3.fill",
                color: AppColors.accentOrange,
                isUnlocked: true,
                progress: 1.0
            ))
        }
        
        if total < 10 {
            result.append(Achievement(
                id: "ten_victories_progress",
                title: "Getting Started",
                description: "Reach 10 victories",
                iconName: "trophy",
                color: AppColors.textTertiary,
                isUnlocked: false,
                progress: Double(total) / 10.0
            ))
        }
        
        if total < 50 {
            result.append(Achievement(
                id: "fifty_victories_progress",
                title: "Half Century",
                description: "Reach 50 victories",
                iconName: "crown",
                color: AppColors.textTertiary,
                isUnlocked: false,
                progress: Double(total) / 50.0
            ))
        }
        
        if streak < 7 {
            result.append(Achievement(
                id: "week_streak_progress",
                title: "Week Warrior",
                description: "Reach 7-day streak",
                iconName: "calendar.badge.clock",
                color: AppColors.textTertiary,
                isUnlocked: false,
                progress: Double(streak) / 7.0
            ))
        }
        
        return result.sorted { $0.isUnlocked && !$1.isUnlocked }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            AchievementStatsView(victories: filteredVictories, achievements: achievements)
            
            AchievementsGridView(achievements: achievements)
            
            NextGoalsView(store: store, victories: filteredVictories, achievements: achievements)
        }
    }
}

struct AchievementStatsView: View {
    let victories: [Victory]
    let achievements: [Achievement]
    
    private var unlockedCount: Int {
        achievements.filter { $0.isUnlocked }.count
    }
    
    private var totalCount: Int {
        achievements.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "trophy.fill")
                    .font(.title3)
                    .foregroundColor(AppColors.primaryYellow)
                
                Text("Achievement Progress")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            HStack {
                VStack(spacing: 4) {
                    Text("\(unlockedCount)")
                        .font(AppFonts.largeTitle)
                        .foregroundColor(AppColors.primaryYellow)
                    
                    Text("Unlocked")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("\(totalCount)")
                        .font(AppFonts.largeTitle)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Total")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("\(Int(Double(unlockedCount) / Double(totalCount) * 100))%")
                        .font(AppFonts.largeTitle)
                        .foregroundColor(AppColors.primaryYellow)
                    
                    Text("Complete")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct AchievementsGridView: View {
    let achievements: [Achievement]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .font(.title3)
                    .foregroundColor(AppColors.accentOrange)
                
                Text("Achievements")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(achievements, id: \.id) { achievement in
                    AchievementCardView(achievement: achievement)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct AchievementCardView: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? achievement.color.opacity(0.2) : AppColors.cardBorder.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.iconName)
                    .font(.title2)
                    .foregroundColor(achievement.isUnlocked ? achievement.color : AppColors.textTertiary)
            }
            
            Text(achievement.title)
                .font(AppFonts.caption1)
                .foregroundColor(achievement.isUnlocked ? AppColors.textPrimary : AppColors.textTertiary)
                .multilineTextAlignment(.center)
            
            if !achievement.isUnlocked {
                ProgressView(value: achievement.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: AppColors.primaryYellow))
                    .frame(height: 4)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(achievement.isUnlocked ? AppColors.cardBackground.opacity(0.5) : AppColors.cardBackground.opacity(0.3))
        .cornerRadius(12)
    }
}

struct NextGoalsView: View {
    @ObservedObject var store: VictoryStore
    let victories: [Victory]
    let achievements: [Achievement]
    
    private var nextGoals: [String] {
        var goals: [String] = []
        let total = victories.count
        let streak = store.getCurrentStreak()
        
        if total < 10 {
            goals.append("🎯 Reach 10 total victories (\(total)/10)")
        } else if total < 50 {
            goals.append("🎯 Reach 50 total victories (\(total)/50)")
        } else if total < 100 {
            goals.append("🎯 Reach 100 total victories (\(total)/100)")
        }
        
        if streak < 7 {
            goals.append("🔥 Build a 7-day streak (\(streak)/7)")
        } else if streak < 30 {
            goals.append("🔥 Build a 30-day streak (\(streak)/30)")
        }
        
        let categories = Set(victories.compactMap { $0.category })
        if categories.count < 3 {
            goals.append("📂 Use 3 different categories (\(categories.count)/3)")
        } else if categories.count < 5 {
            goals.append("📂 Use 5 different categories (\(categories.count)/5)")
        }
        
        return goals
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "target")
                    .font(.title3)
                    .foregroundColor(AppColors.accentPurple)
                
                Text("Next Goals")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(nextGoals, id: \.self) { goal in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.accentPurple)
                        
                        Text(goal)
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct Achievement {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let color: Color
    let isUnlocked: Bool
    let progress: Double
}

