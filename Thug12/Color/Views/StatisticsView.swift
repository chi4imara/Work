import SwiftUI


struct StatisticsView: View {
    @ObservedObject var weatherData: WeatherDataManager
    @ObservedObject var appState: AppStateManager
    @State private var selectedPeriod: StatisticsPeriod = .month
    @State private var animateStats = false
    @State private var selectedTab: StatsTab = .overview
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(AppColors.accentYellow.opacity(0.1))
                    .frame(width: CGFloat.random(in: 4...12), height: CGFloat.random(in: 4...12))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(.easeInOut(duration: Double.random(in: 3...6)).repeatForever(autoreverses: true), value: animateStats)
            }
            
            VStack(spacing: 0) {
                modernHeaderView
                
                if weatherData.weatherEntries.isEmpty {
                    modernEmptyStateView
                } else {
                    tabSelectorView
                    
                    ScrollView {
                        VStack(spacing: AppSpacing.xl) {
                            switch selectedTab {
                            case .overview:
                                overviewContent
                            case .colors:
                                colorsContent
                            case .trends:
                                trendsContent
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.md)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animateStats = true
            }
        }
    }
    
    private var modernHeaderView: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Statistics")
                        .font(Font.poppinsBold(size: 18))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Your weather journey")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: AppSpacing.xs) {
                    Text("\(weatherData.getTotalDaysCount())")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.primaryOrange)
                        .fontWeight(.bold)
                    
                    Text("days tracked")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.md)
    }
    
    private var tabSelectorView: some View {
        HStack(spacing: 0) {
            ForEach(StatsTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: AppSpacing.xs) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(selectedTab == tab ? AppColors.primaryOrange : AppColors.secondaryText)
                        
                        Text(tab.title)
                            .font(AppFonts.caption)
                            .foregroundColor(selectedTab == tab ? AppColors.primaryOrange : AppColors.secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppCornerRadius.small)
                            .fill(selectedTab == tab ? AppColors.primaryOrange.opacity(0.2) : Color.clear)
                    )
                }
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.sm)
    }
    
    private var overviewContent: some View {
        VStack(spacing: AppSpacing.xl) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppSpacing.md), count: 2), spacing: AppSpacing.md) {
                ModernStatCard(
                    title: "Total Days",
                    value: "\(weatherData.getTotalDaysCount())",
                    icon: "calendar",
                    color: AppColors.primaryOrange,
                    animationDelay: 0.1
                )
                
                ModernStatCard(
                    title: "Streak",
                    value: "\(calculateStreak())",
                    icon: "flame",
                    color: AppColors.error,
                    animationDelay: 0.2
                )
                
                ModernStatCard(
                    title: "Last Entry",
                    value: lastEntryText,
                    icon: "clock",
                    color: AppColors.accentYellow,
                    animationDelay: 0.3
                )
                
                ModernStatCard(
                    title: "Favorite",
                    value: mostUsedColor,
                    icon: "heart",
                    color: AppColors.success,
                    animationDelay: 0.4
                )
            }
            
            recentActivityView
        }
    }
    
    private var colorsContent: some View {
        VStack(spacing: AppSpacing.xl) {
            modernColorDistributionView
            
            colorInsightsView
        }
    }
    
    private var trendsContent: some View {
        VStack(spacing: AppSpacing.xl) {
            periodSelectorView
            
            modernActivityChartView
            
            trendAnalysisView
        }
    }
    
    private var modernColorDistributionView: some View {
        VStack(spacing: AppSpacing.lg) {
            HStack {
                Text("Color Distribution")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(weatherData.getTotalDaysCount()) total")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            ZStack {
                Circle()
                    .stroke(AppColors.primaryOrange.opacity(0.1), lineWidth: 20)
                    .opacity(animateStats ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.5), value: animateStats)
                
                ForEach(colorDistribution.indices) { index in
                    let item = colorDistribution[index]
                    let percentage = Double(item.value) / Double(weatherData.getTotalDaysCount())
                    
                    let totalCount = Double(weatherData.getTotalDaysCount())
                    let startAngle = colorDistribution.prefix(index).reduce(0.0) { result, item in
                        result + (Double(item.value) / totalCount)
                    }
                    
                    Circle()
                        .trim(from: CGFloat(startAngle), to: CGFloat(startAngle + percentage))
                        .stroke(
                            getColorForName(item.key),
                            style: StrokeStyle(
                                lineWidth: 18,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                        .rotationEffect(.degrees(-90))
                        .shadow(
                            color: getColorForName(item.key).opacity(0.3),
                            radius: 3,
                            x: 0,
                            y: 2
                        )
                        .opacity(animateStats ? 1.0 : 0.0)
                        .scaleEffect(animateStats ? 1.0 : 0.0)
                        .animation(
                            .spring(
                                response: 0.8,
                                dampingFraction: 0.7,
                                blendDuration: 0.3
                            ).delay(Double(index) * 0.15),
                            value: animateStats
                        )
                }
                
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 140, height: 140)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .opacity(animateStats ? 1.0 : 0.0)
                    .scaleEffect(animateStats ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.4).delay(0.3), value: animateStats)
                
                Text("\(weatherData.getTotalDaysCount()) days")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.secondaryText)
                    .opacity(animateStats ? 0.8 : 0.0)
                    .scaleEffect(animateStats ? 1.0 : 0.5)
                    .animation(.easeOut(duration: 0.4).delay(0.5), value: animateStats)
            }
            .frame(width: 240, height: 240)
            .padding(AppSpacing.xl)
            .background(
                Circle()
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.primaryOrange.opacity(0.25), radius: 15, x: 0, y: 8)
                    .overlay(
                        Circle()
                            .stroke(LinearGradient(
                                colors: [AppColors.primaryOrange.opacity(0.3), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ), lineWidth: 1)
                    )
            )
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppSpacing.sm), count: 2), spacing: AppSpacing.sm) {
                ForEach(colorDistribution.indices, id: \.self) { index in
                    let item = colorDistribution[index]
                    ModernColorLegendItem(
                        colorName: item.key,
                        count: item.value,
                        percentage: Double(item.value) / Double(weatherData.getTotalDaysCount()) * 100,
                        color: getColorForName(item.key),
                        animationDelay: Double(index) * 0.1 + 0.5
                    )
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primaryText.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var modernActivityChartView: some View {
        VStack(spacing: AppSpacing.lg) {
            HStack {
                Text("Activity Trends")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            if !chartData.isEmpty {
                ModernLineChart(data: chartData)
                    .frame(height: 250)
                    .padding(AppSpacing.lg)
                    .background(
                        RoundedRectangle(cornerRadius: AppCornerRadius.large)
                            .fill(AppColors.cardGradient)
                            .shadow(color: AppColors.primaryText.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    .opacity(animateStats ? 1.0 : 0.0)
                    .scaleEffect(animateStats ? 1.0 : 0.8)
                    .animation(.easeInOut(duration: 0.8).delay(0.5), value: animateStats)
            } else {
                VStack(spacing: AppSpacing.md) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("No data for selected period")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(height: 250)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: AppCornerRadius.large)
                        .fill(AppColors.cardGradient)
                )
            }
        }
    }
    
    private var modernEmptyStateView: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryOrange.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.primaryOrange)
            }
            
            VStack(spacing: AppSpacing.md) {
                Text("No Statistics Yet")
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Start tracking your weather colors to see beautiful insights and trends")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.lg)
            }
            
            Button(action: {
                appState.showColorPicker(for: Date())
            }) {
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: "plus.circle.fill")
                    Text("Mark Today")
                }
                .font(AppFonts.button)
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, AppSpacing.xl)
                .padding(.vertical, AppSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .fill(AppColors.primaryOrange)
                        .shadow(color: AppColors.primaryOrange.opacity(0.3), radius: 8, x: 0, y: 4)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
    }
    
    private var colorDistribution: [(key: String, value: Int)] {
        weatherData.getColorDistribution().map { (key: $0.key, value: $0.value) }.sorted { $0.value > $1.value }
    }
    
    private var lastEntryText: String {
        guard let lastDate = weatherData.getLastEntryDate() else { return "None" }
        return dateFormatter.string(from: lastDate)
    }
    
    private var chartData: [ChartDataPoint] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .week:
            let startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            return generateChartData(from: startDate, to: now, component: .day)
        case .month:
            let startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return generateChartData(from: startDate, to: now, component: .day)
        case .year:
            let startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            return generateChartData(from: startDate, to: now, component: .month)
        }
    }
    
    private func generateChartData(from startDate: Date, to endDate: Date, component: Calendar.Component) -> [ChartDataPoint] {
        let calendar = Calendar.current
        var data: [ChartDataPoint] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            let count = weatherData.weatherEntries.filter { entry in
                calendar.isDate(entry.date, equalTo: currentDate, toGranularity: component)
            }.count
            
            data.append(ChartDataPoint(date: currentDate, count: count))
            
            currentDate = calendar.date(byAdding: component, value: 1, to: currentDate) ?? endDate
        }
        
        return data
    }
    
    private func getColorForName(_ name: String) -> Color {
        return WeatherColor.predefinedColors.first { $0.displayName == name }?.swiftUIColor ?? .gray
    }
    
    private var mostUsedColor: String {
        let distribution = weatherData.getColorDistribution()
        return distribution.max(by: { $0.value < $1.value })?.key ?? "None"
    }
    
    private func calculateStreak() -> Int {
        let entries = weatherData.weatherEntries.sorted { $0.date > $1.date }
        var streak = 0
        let calendar = Calendar.current
        var currentDate = Date()
        
        for entry in entries {
            if calendar.isDate(entry.date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    private var recentActivityView: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                Text("Recent Activity")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            VStack(spacing: AppSpacing.sm) {
                ForEach(Array(weatherData.weatherEntries.prefix(5).enumerated()), id: \.element.id) { index, entry in
                    RecentActivityRow(entry: entry, animationDelay: Double(index) * 0.1)
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primaryText.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var colorInsightsView: some View {
        VStack(spacing: AppSpacing.lg) {
            Text("Color Insights")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppSpacing.md), count: 2), spacing: AppSpacing.md) {
                InsightCard(
                    title: "Most Used",
                    value: mostUsedColor,
                    icon: "star.fill",
                    color: AppColors.accentYellow
                )
                
                InsightCard(
                    title: "Diversity",
                    value: "\(colorDistribution.count) colors",
                    icon: "paintpalette.fill",
                    color: AppColors.success
                )
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primaryText.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var periodSelectorView: some View {
        HStack(spacing: AppSpacing.sm) {
            ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedPeriod = period
                    }
                }) {
                    Text(period.rawValue)
                        .font(AppFonts.callout)
                        .foregroundColor(selectedPeriod == period ? AppColors.primaryText : AppColors.secondaryText)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                                .fill(selectedPeriod == period ? AnyShapeStyle(AppColors.primaryOrange) : AnyShapeStyle(AppColors.cardGradient))
                        )
                }
            }
        }
    }
    
    private var trendAnalysisView: some View {
        VStack(spacing: AppSpacing.md) {
            Text("Trend Analysis")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Your weather tracking shows consistent patterns. Keep up the great work!")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.leading)
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primaryText.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

enum StatsTab: String, CaseIterable {
    case overview = "Overview"
    case colors = "Colors"
    case trends = "Trends"
    
    var icon: String {
        switch self {
        case .overview: return "chart.bar"
        case .colors: return "paintpalette"
        case .trends: return "chart.line.uptrend.xyaxis"
        }
    }
    
    var title: String {
        return rawValue
    }
}

enum StatisticsPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct ChartDataPoint {
    let date: Date
    let count: Int
}

struct ModernStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let animationDelay: Double
    
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: AppSpacing.xs) {
                Text(value)
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(AppColors.cardGradient)
                .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
        )
        .opacity(animate ? 1.0 : 0.0)
        .scaleEffect(animate ? 1.0 : 0.8)
        .animation(.easeInOut(duration: 0.6).delay(animationDelay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

struct ModernColorLegendItem: View {
    let colorName: String
    let count: Int
    let percentage: Double
    let color: Color
    let animationDelay: Double
    
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Circle()
                .fill(color)
                .frame(width: 16, height: 16)
                .overlay(
                    Circle()
                        .stroke(AppColors.primaryText.opacity(0.3), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(colorName)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(count) days")
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Text(String(format: "%.0f%%", percentage))
                .font(AppFonts.caption)
                .foregroundColor(AppColors.primaryOrange)
                .fontWeight(.semibold)
        }
        .padding(AppSpacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.small)
                .fill(AppColors.primaryText.opacity(0.05))
        )
        .opacity(animate ? 1.0 : 0.0)
        .offset(x: animate ? 0 : -20)
        .animation(.easeInOut(duration: 0.5).delay(animationDelay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

struct ModernLineChart: View {
    let data: [ChartDataPoint]
    
    private var maxValue: Int {
        data.map(\.count).max() ?? 1
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            GeometryReader { geometry in
                ZStack {
                    ForEach(0..<5, id: \.self) { index in
                        Rectangle()
                            .fill(AppColors.primaryText.opacity(0.1))
                            .frame(height: 1)
                            .offset(y: CGFloat(index) * geometry.size.height / 4 - geometry.size.height / 2)
                    }
                    
                    Path { path in
                        guard !data.isEmpty else { return }
                        
                        let width = geometry.size.width
                        let height = geometry.size.height
                        let stepX = width / CGFloat(data.count - 1)
                        
                        for (index, point) in data.enumerated() {
                            let x = CGFloat(index) * stepX
                            let y = height - (CGFloat(point.count) / CGFloat(maxValue)) * height
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(
                        LinearGradient(
                            colors: [AppColors.primaryOrange, AppColors.accentYellow],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                    )
                    
                    ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                        let x = CGFloat(index) * (geometry.size.width / CGFloat(data.count - 1))
                        let y = geometry.size.height - (CGFloat(point.count) / CGFloat(maxValue)) * geometry.size.height
                        
                        Circle()
                            .fill(AppColors.primaryOrange)
                            .frame(width: 8, height: 8)
                            .position(x: x, y: y)
                    }
                }
            }
            .frame(height: 150)
            
            HStack {
                ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                    if index % max(1, data.count / 5) == 0 {
                        Text(dateFormatter.string(from: point.date))
                            .font(Font.poppinsRegular(size: 9))
                            .foregroundColor(AppColors.secondaryText)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

struct RecentActivityRow: View {
    let entry: WeatherEntry
    let animationDelay: Double
    
    @State private var animate = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Circle()
                .fill(entry.weatherColor.swiftUIColor)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.weatherColor.displayName)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryText)
                
                Text(dateFormatter.string(from: entry.date))
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
        .opacity(animate ? 1.0 : 0.0)
        .offset(x: animate ? 0 : -20)
        .animation(.easeInOut(duration: 0.5).delay(animationDelay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

struct InsightCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(title)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .fill(AppColors.primaryText.opacity(0.05))
        )
    }
}

#Preview {
    StatisticsView(weatherData: WeatherDataManager(), appState: AppStateManager())
}
